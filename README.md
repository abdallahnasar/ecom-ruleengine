# PHP Laravel E-commerce Rule Engine

1- install package to your laravel project using command:

composer require abdallah/ecom-rulengine



2-add 

Abdallah\EcomRuleEngine\RuleEngineServiceProvider::class 

to providers array in your config/app.php

and

'RuleEngine' => \Abdallah\EcomRuleEngine\Facades\RuleEngineFacade::class

 inside aliases merge array.


3- run:

php artisan vendor:publish

and select to publish the class provider you just added to providers config.


4- run:
php artisan vendor:publish --tag=public --force

to publish css,js files and rules.json where you can change rules conditions and actions.

5- on your browser hit route "/rule-engine" to test rules by submitting a simple frontend,
add to cart form by adding one or more items(name & quantity) 
and hit submit to check or validate rules.

6- if you want to run unit test of package and test all cases you can run 
./vendor/bin/phpunit
inside package directory vendor/abdallah/ecom-rulengine after running 
composer update.

or extend TestCase and RuleEngineText to your project tests dir and add your testcases but make sure (in this case) you installed:
orchestra/testbench package as it is --dev dependency to our package.
