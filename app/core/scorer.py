def score(results):
    total = len(results)
    if total == 0:
        return 0.0

    points = 0

    for r in results:
        if r["type"] == "correct":
            points += 1
        elif r["type"] == "acceptable":
            points += 0.8  # Partial credit for acceptable variations (Indian Accent)
        elif r["type"] == "wrong":
            points += 0.3
        elif r["type"] == "missing":
            points += 0
        elif r["type"] == "extra":
            points += 0

    return round(points / total, 2)