<?php
namespace Abdallah\EcomRuleEngine\Tests;

use Abdallah\EcomRuleEngine\Facades\RuleEngineFacade;
use Abdallah\EcomRuleEngine\RuleEngineServiceProvider;
use JetBrains\PhpStorm\ArrayShape;
use Orchestra\Testbench\TestCase as OrchestraTestCase;

class TestCase extends OrchestraTestCase
{
    /**
     * @param \Illuminate\Foundation\Application $app
     * @return string[]
     */
    protected function getPackageProviders($app): array
    {
        return [RuleEngineServiceProvider::class];
    }

    /**
     * @param \Illuminate\Foundation\Application $app
     * @return string[]
     */
    protected function getPackageAliases($app): array
    {
        return [
            'ruleEngine' => RuleEngineFacade::class,
        ];
    }
}
