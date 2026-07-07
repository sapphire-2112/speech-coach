PAIR_TIPS = {
    ("v", "w"): "For V, touch upper teeth to lower lip. For W, round both lips without teeth.",
    ("w", "v"): "For W, round both lips. For V, lightly vibrate lower lip against upper teeth.",
    ("th", "t"): "For TH, place the tongue tip lightly between teeth and release air.",
    ("dh", "d"): "For voiced TH, keep tongue between teeth and add voice vibration.",
    ("r", "l"): "For R, pull the tongue back slightly. For L, touch tongue tip behind teeth.",
    ("s", "sh"): "For SH, round lips slightly and widen the air channel. For S, keep lips flatter.",
}


def generate_feedback(results, score_value=None):
    mistakes = [item for item in results if item["type"] not in {"correct", "accent_match"}]
    feedback = []
    improvements = []

    if not results:
        return {
            "summary": "No clear speech detected. Please try again closer to the microphone.",
            "feedback": ["No clear speech detected."],
            "mistakes": [],
            "improvements": ["Speak one line clearly, with normal volume, and retry."],
        }

    if score_value is None:
        score_value = 0

    if score_value >= 90:
        summary = "Excellent clarity. Your pronunciation is confident and easy to understand."
    elif score_value >= 75:
        summary = "Good attempt. A few sounds need more control."
    elif score_value >= 55:
        summary = "Understandable, but several sounds need slower practice."
    else:
        summary = "Many sounds were unclear. Slow down and rebuild the word sound by sound."

    if not mistakes:
        feedback.append("All checked sounds were clear.")
        improvements.append("Repeat once at natural speed to build fluency.")
    else:
        issue_counts = {}
        for item in mistakes:
            key = item["type"]
            issue_counts[key] = issue_counts.get(key, 0) + 1

        if issue_counts.get("missing"):
            feedback.append(f"{issue_counts['missing']} sound(s) were missed.")
            improvements.append("Slow down and finish the final sound of each word.")
        if issue_counts.get("extra"):
            feedback.append(f"{issue_counts['extra']} extra sound(s) were added.")
            improvements.append("Keep the word compact. Avoid adding small vowel sounds between consonants.")
        if issue_counts.get("wrong"):
            feedback.append(f"{issue_counts['wrong']} sound(s) were pronounced differently.")
        if issue_counts.get("close"):
            feedback.append(f"{issue_counts['close']} sound(s) were close but need sharper clarity.")

        for item in mistakes[:4]:
            pair = (item.get("expected"), item.get("spoken"))
            if pair in PAIR_TIPS:
                improvements.append(PAIR_TIPS[pair])
            elif item.get("tip"):
                improvements.append(item["tip"])

    return {
        "summary": summary,
        "feedback": _unique(feedback),
        "mistakes": mistakes[:8],
        "improvements": _unique(improvements)[:6],
    }


def _unique(items):
    seen = set()
    output = []
    for item in items:
        if item and item not in seen:
            seen.add(item)
            output.append(item)
    return output
