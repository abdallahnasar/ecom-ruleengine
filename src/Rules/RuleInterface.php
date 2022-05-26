<?php

namespace Abdallah\EcomRuleEngine\Rules;

interface RuleInterface
{
    /**
     * @param array $condition
     * @return string
     */
    public function generate(array $condition): string;
}
