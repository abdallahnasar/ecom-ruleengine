<?php
namespace Abdallah\EcomRuleEngine\Entities;


class Cart
{
    //TODO: add mapping relations like "hasMany" in models instead of array
    public array $items;
    private ?bool $repeatingCustomer;
    private ?string $promoCode;
    private ?bool $neverOrdered;

    /**
     * @return int
     */
    public function getTotal(): int
    {
        $total = 0;
        foreach ($this->items as $item) {
            $total += $item->getQuantity();
        }
        return $total;
    }

    /**
     * @param Item $item
     */
    public function addItem(Item $item)
    {
        $this->items[] = $item;
    }

    /**
     * @return int
     */
    public function getCartSize(): int
    {
        return count($this->items);
    }

    /**
     * @param bool|null $repeatingCustomer
     */
    public function setRepeatingCustomer(?bool $repeatingCustomer): void
    {
        $this->repeatingCustomer = $repeatingCustomer;
    }

    /**
     * @return bool|null
     */
    public function getRepeatingCustomer(): ?bool
    {
        return $this->repeatingCustomer;
    }

    /**
     * @param string|null $promoCode
     */
    public function setPromoCode(?string $promoCode): void
    {
        $this->promoCode = $promoCode;
    }

    /**
     * @return string|null
     */
    public function getPromoCode(): ?string
    {
        return $this->promoCode;
    }

    /**
     * @param bool|null $neverOrdered
     */
    public function setNeverOrdered(?bool $neverOrdered): void
    {
        $this->neverOrdered = $neverOrdered;
    }

    /**
     * @return bool|null
     */
    public function getNeverOrdered(): ?bool
    {
        return $this->neverOrdered;
    }

    /**
     * @param string $name
     * @return bool
     */
    public function searchItemByName(string $name): bool
    {
        foreach ($this->items as $item) {
            return $item->getName() == $name;
        }

        return false;
    }

    /**
     * @param int $quantity
     * @return bool
     */
    public function searchItemByQuantity(int $quantity): bool
    {
        foreach ($this->items as $item) {
            return $item->getQuantity() == $quantity;
        }

        return false;
    }

    /**
     * @param array $data
     * @return Cart
     */
    public function create(array $data): Cart
    {

        $cartItems = json_decode($data['cart'], true);
        foreach ($cartItems as $itemName => $itemQuantity) {
            $this->addItem(new Item($itemName, $itemQuantity));
        }
        $this->setRepeatingCustomer($data['repeating_customer'] ?? null);
        $this->setPromoCode($data['promo_code'] ?? null);
        $this->setNeverOrdered($data['never_ordered'] ?? null);

        return $this;
    }

}
