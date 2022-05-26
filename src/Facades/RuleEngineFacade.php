<?php

namespace Abdallah\EcomRuleEngine\Facades;

use Illuminate\Support\Facades\Facade;

/**
 * Class RuleEngineFacade
 * @package Abdallah\EcomRuleEngine
 */
class RuleEngineFacade extends Facade
{
    /**
     * @return string
     */
    protected static function getFacadeAccessor(): string
    {
        return 'ruleEngine';
    }
}
