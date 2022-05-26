<?php

namespace Abdallah\EcomRuleEngine;

use Illuminate\Support\ServiceProvider;
use Abdallah\EcomRuleEngine\Services\RuleEngine;

class RuleEngineServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind('ruleEngine', function(){
            return new RuleEngine();
        });

    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        $this->loadRoutesFrom(__DIR__.'/routes/web.php');
        $this->loadViewsFrom(__DIR__.'/resources/views', 'ruleEngine');
        $this->publishes([
            __DIR__ . '/config/rule-engine.php' => config_path('rule-engine.php')
        ]);
        $this->publishes([
            __DIR__ . '/public/Storage.js' => public_path('Storage.js'),
            __DIR__ . '/public/rules.json' => public_path('rules.json'),
        ], 'public');

    }
}
