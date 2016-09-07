<?php

use Behat\Testwork\Tester\Result\TestResult;
use Behat\Mink\Driver\Selenium2Driver;

class ScreenshotContext extends PageObjectExtension
{
    protected $scenarioTitle = null;
    protected static $wsendUser = null;
    protected $basicScreenshotFolder = 'artifacts/screenshots';

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
        if(!is_dir($this->basicScreenshotFolder)) {
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

        exec(sprintf(
                'curl -F "uid=%s" -F "filehandle=@%s" %s 2>/dev/null',
                self::$wsendUser,
                $filename,
                'https://wsend.net/upload_cli'
        ), $output, $return);

        return $output[0];
    }

    protected function getWsendUser()
    {
        // Create a wsend anonymous user.
        $curl = curl_init('https://wsend.net/createunreg');
        curl_setopt($curl, CURLOPT_POSTFIELDS, 'start=1');
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

        $wsendUser = curl_exec($curl);
        curl_close($curl);

        return $wsendUser;
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
