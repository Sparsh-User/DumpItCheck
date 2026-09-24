/* Legacy class on an old API version - tests API-version drift detection */
global class LegacyPricingEngine {
    global static Decimal calculate(Decimal base, Decimal discount) {
        if (discount == null) { discount = 0; }
        return base - (base * discount / 100);
    }
    global interface PriceRule { Decimal apply(Decimal amount); }
    global class FlatRule implements PriceRule {
        global Decimal apply(Decimal amount) { return amount - 10; }
    }
}
