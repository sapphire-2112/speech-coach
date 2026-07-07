VOWELS = {"a", "e", "i", "o", "u", "ai", "au", "oi", "ee", "oo", "aw", "er"}


def score(results):
    total_weight = 0
    earned = 0

    for item in results:
        expected = item.get("expected") or item.get("spoken") or ""
        weight = 1.35 if expected in VOWELS else 1.0
        total_weight += weight

        kind = item["type"]
        if kind == "correct":
            earned += weight
        elif kind == "accent_match":
            earned += weight * 0.95
        elif kind == "close":
            earned += weight * 0.65
        elif kind == "wrong":
            earned += weight * 0.15

    if total_weight == 0:
        return 0

    return round((earned / total_weight) * 100)


def score_breakdown(results):
    buckets = {
        "correct": 0,
        "accent_match": 0,
        "close": 0,
        "wrong": 0,
        "missing": 0,
        "extra": 0,
        "vowel_issues": 0,
        "consonant_issues": 0,
    }

    for item in results:
        kind = item["type"]
        if kind in buckets:
            buckets[kind] += 1
        if kind not in {"correct", "accent_match"}:
            key = "vowel_issues" if item.get("sound_group") == "vowel" else "consonant_issues"
            buckets[key] += 1

    return buckets
