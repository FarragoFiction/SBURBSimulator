

double smoothstep(double n) {
    n = n.clamp(0.0, 1.0);

    return n * n * (3 - 2 * n);
}

double smoothstepRange(double min, double max, double val) {
    double n = (val - min)/(max-min);
    n = smoothstep(n);
    return min + n * (max-min);
}

/// Polynomial smoothed maximum of a and b.
///
/// Acts the same as max(a,b) except when the difference is less than diff, where smoothing occurs.
double polymax(double a, double b, double diff) {
    double h = (0.5 + 0.5 * (b-a) / diff).clamp(0.0, 1.0);
    return (b * h + a * (1.0 - h)) + diff * h * (1.0 - h);
}

double smoothCap(double val, double limit, double startval, double divisor) {
    double n = (val - startval)/(limit - startval);

    double mix = smoothstep(n);

    n = (1-mix) * n + mix * (n / (divisor + n));

    return startval + n * (limit - startval);
}