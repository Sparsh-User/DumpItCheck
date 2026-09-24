import { LightningElement, api } from 'lwc';
import { computePercent } from './gaugeMath';

export default class BudgetGauge extends LightningElement {
    @api spent = 0;
    @api budget = 0;
    get percent() {
        return computePercent(this.spent, this.budget);
    }
}
