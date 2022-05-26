<?php

namespace Abdallah\EcomRuleEngine\Tests;


use Abdallah\EcomRuleEngine\Entities\Cart;
use ruleEngine;
class RuleEngineTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp(); // TODO: Change the autogenerated stub
        $config['path'] = 'rules.json';
        config()->set('rule-engine',  [
            'type' => 'json', // other values yml, excel
            'path' => 'rules.json', // path of rules file in public folder
        ]);
    }

    public function testCaseA()
    {
        $data = [
            "cart" => '{"MoonShiner Howling Wolf":"1","MoonShiner The Answer":"1","MoonShiner Pro":"1","MoonShiner Special":"1","MoonShiner WeAreMoonShiner":"1"}',
            "repeating_customer" => 1,
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertSame('5 € Off the total', $result['string']);
    }

    public function testCaseA1MoreThan4Items()
    {
        $data = [
            "cart" => '{"MoonShiner Howling Wolf":"2","MoonShiner The Answer":"1","MoonShiner Pro":"1","MoonShiner Special":"3","MoonShiner WeAreMoonShiner":"1","MoonShiner Hoodie":"1"}',
            "repeating_customer" => 1,
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertSame('5 € Off the total', $result['string']);
    }


    public function testCaseA2Only4DifferentItems()
    {
        $data = [
            "cart" => '{"MoonShiner Howling Wolf":"2","MoonShiner The Answer":"1","MoonShiner Pro":"1","MoonShiner Special":"3"}',
            "repeating_customer" => 1,
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertNotSame('5 € Off the total', $result['string']);
    }

    public function testCaseA3Only3DifferentItems()
    {
        $data = [
            "cart" => '{"MoonShiner Howling Wolf":"2","MoonShiner Pro":"1","MoonShiner Special":"3"}',
            "repeating_customer" => 1,
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertNotSame('5 € Off the total', $result['string']);
    }



    public function testCaseB()
    {
        $data = [
            "cart" => '{"MoonShiner Howling Wolf":"2"}',
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertSame('Get the first one free', $result['string']);
    }

    public function testCaseC()
    {
        $data = [
            "cart" => '{"MoonShiner Howling Wolf":"1"}',
            "never_ordered" => 1,
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertSame('Get the special “OneHoodie” for free', $result['string']);
    }

    public function testCaseD()
    {
        $data = [
            "cart" => '{"MoonShiner Howling Wolf":"1"}',
            "promo_code" => 'Welcome1337',
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertSame('Free Purchase', $result['string']);
    }


    public function testCaseE1()
    {
        $data = [
            "cart" => '{"ProductA": "1", "MoonShiner Howling Wolf":"1"}',
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertSame('get first one free', $result['string']);
    }

    public function testCaseE2()
    {
        $data = [
            "cart" => '{"ProductB": "1", "MoonShiner Howling Wolf":"1"}',
        ];

        $result = ruleEngine::validateCart((new Cart())->create($data));
        return $this->assertSame('get first one free', $result['string']);
    }


}
