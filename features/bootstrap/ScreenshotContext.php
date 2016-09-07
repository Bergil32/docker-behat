<?php

use Behat\Testwork\Tester\Result\TestResult;
use Behat\Mink\Driver\Selenium2Driver;
use GuzzleHttp\Client;

class ScreenshotContext extends PageObjectExtension
{
    protected $scenarioTitle = null;
    protected static $wsendUser = null;
    protected $basicScreenshotFolder = 'artifacts/screenshots';

    /**
     * Guzzle client.
     *
     * @var \GuzzleHttp\Client
     */
    protected $guzzle;

    /**
     * ScreenshotContext constructor.
     */
    public function __construct()
    {
        parent::__construct();

        // Initialize Guzzle client.
        $this->guzzle = new Client();
    }

    /**
     * @BeforeScenario
     */
    public function cacheScenarioName($event)
    {
        // It's only to have a clean screenshot name later.
        $this->scenarioTitle = $event->getScenario()->getTitle();
    }

    /**
     * @AfterStep
     */
    public function takeScreenshotAfterFailedStep($event)
    {
        if ($event->getTestResult()->getResultCode() !== TestResult::FAILED) {
            return;
        }

        $this->takeAScreenshot();
    }

    /**
     * Create directories for screenshots
     */
    protected function folderForScreenshots()
    {
        if (!is_dir($this->basicScreenshotFolder)) {
            mkdir($this->basicScreenshotFolder);
        }
    }

    /**
     * Writing information about screenshots to file.
     */
    private function writeUrl($url)
    {
        $folder = sprintf('%s/%s',$this->basicScreenshotFolder, date('Y-m-d') );
        $savedData = sprintf("%s / Scenario - %s / %s\n", date('H:i:s'), $this->scenarioTitle, $url);

        $this->folderForScreenshots();
        file_put_contents($folder, $savedData, FILE_APPEND);
    }

    /**
     * @Then take a screenshot
     */
    public function takeAScreenshot()
    {
        if (!$this->isJavascript()) {
            print "Screenshot cannot be taken from non javascript scenario.\n";

            return;
        }

        $screenshot = $this->getSession()->getDriver()->getScreenshot();

        $filename = $this->getScreenshotFilename();
        file_put_contents($filename, $screenshot);

        $url = $this->getScreenshotUrl($filename);

        print sprintf("Screenshot is available :\n%s", $url);
        $this->writeUrl($url);
    }

    protected function getScreenshotUrl($filename)
    {
        if (!self::$wsendUser) {
            self::$wsendUser = $this->getWsendUser();
        }

        // Send screenshot to Wsend.
        $response = $this->guzzle->post(
          'https://wsend.net/upload_cli',
          [
            'multipart' => [
              [
                'name' => 'uid',
                'contents' => ScreenshotContext::$wsendUser,
              ],
              [
                'name' => 'filehandle',
                'contents' => fopen($filename, 'r'),
              ],
            ],
          ]
        );

        return $response->getBody();
    }

    protected function getWsendUser()
    {
        return $this
          ->guzzle
          ->post(
            'https://wsend.net/createunreg',
            [
              'form_params' => [
                'start' => 1,
              ],
            ]
          )
          ->getBody();
    }

    protected function getScreenshotFilename()
    {
        $filename = $this->scenarioTitle;
        $filename = preg_replace("#[^a-zA-Z0-9\._-]#", '_', $filename);

        return sprintf('%s/%s.png', sys_get_temp_dir(), $filename);
    }

    protected function isJavascript()
    {
        return $this->getSession()->getDriver() instanceof Selenium2Driver;
    }
}
