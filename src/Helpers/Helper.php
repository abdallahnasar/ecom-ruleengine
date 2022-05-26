<?php

namespace Abdallah\EcomRuleEngine\Helpers;


class Helper
{
    /**
     * function replace underscores to PascalCase (camelCase) first letter capitalized
     * @param string $string
     * @return string
     */
    public static function underscoresToPascalCase(string $string): string
    {
        return str_replace(' ', '', ucwords(str_replace('_', ' ', $string)));
    }

}
