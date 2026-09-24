export function computePercent(spent, budget) {
    if (!budget) {
        return 0;
    }
    return Math.round((spent / budget) * 100);
}
