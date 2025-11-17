# ==========================================
# 📁 clean_fifa_tables.py
# ==========================================
import pandas as pd

# ---------- 1️⃣ Clean results.csv ----------
def clean_results(path="results.csv"):
    df = pd.read_csv(path)
    df['date'] = pd.to_datetime(df['date'], errors='coerce')
    df['year'] = df['date'].dt.year
    df['month'] = df['date'].dt.month
    df['era'] = (df['year'] // 10) * 10

    df['match_key'] = (
        df['date'].dt.strftime('%Y-%m-%d') + '|' +
        df['home_team'] + '|' + df['away_team']
    )

    df.drop_duplicates(subset=['match_key'], inplace=True)

    df['result_label'] = df.apply(
        lambda r: 'Home Win' if r.home_score > r.away_score
        else ('Away Win' if r.home_score < r.away_score else 'Draw'),
        axis=1
    )

    df['goal_diff'] = df['home_score'] - df['away_score']
    df['total_goals'] = df['home_score'] + df['away_score']
    df['venue_type'] = df['neutral'].apply(lambda x: 'Neutral' if x else 'Home Venue Country')

    return df


# ---------- 2️⃣ Clean shootouts.csv ----------
def clean_shootouts(path="shootouts.csv"):
    df = pd.read_csv(path)
    df['date'] = pd.to_datetime(df['date'], errors='coerce')
    df['match_key'] = (
        df['date'].dt.strftime('%Y-%m-%d') + '|' +
        df['home_team'] + '|' + df['away_team']
    )
    df.drop_duplicates(subset=['match_key'], inplace=True)
    return df


# ---------- 3️⃣ Clean goalscorers.csv ----------
def clean_goalscorers(path="goalscorers.csv"):
    df = pd.read_csv(path)
    df['date'] = pd.to_datetime(df['date'], errors='coerce')
    df['match_key'] = (
        df['date'].dt.strftime('%Y-%m-%d') + '|' +
        df['home_team'] + '|' + df['away_team']
    )
    df['own_goal'] = df['own_goal'].astype(bool)
    df['penalty'] = df['penalty'].astype(bool)
    return df


# ---------- 4️⃣ Clean former_names.csv ----------
def clean_former_names(path="former_names.csv"):
    df = pd.read_csv(path)
    df['start_date'] = pd.to_datetime(df['start_date'], errors='coerce')
    df['end_date'] = pd.to_datetime(df['end_date'], errors='coerce')
    df.drop_duplicates(subset=['former', 'current'], inplace=True)
    return df


# ---------- 5️⃣ Save cleaned versions ----------
if __name__ == "__main__":
    results = clean_results("results.csv")
    shootouts = clean_shootouts("shootouts.csv")
    goalscorers = clean_goalscorers("goalscorers.csv")
    former_names = clean_former_names("former_names.csv")

    results.to_csv("clean_results.csv", index=False)
    shootouts.to_csv("clean_shootouts.csv", index=False)
    goalscorers.to_csv("clean_goalscorers.csv", index=False)
    former_names.to_csv("clean_former_names.csv", index=False)

    print("✅ All tables cleaned and saved successfully.")
