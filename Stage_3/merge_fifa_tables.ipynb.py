# ==========================================
# 📁 merge_fifa_tables.py
# ==========================================
import pandas as pd

def merge_fifa_data(
    results_path="clean_results.csv",
    shootouts_path="clean_shootouts.csv",
    goalscorers_path="clean_goalscorers.csv"
):
    # Load cleaned datasets
    results = pd.read_csv(results_path)
    shootouts = pd.read_csv(shootouts_path)
    goalscorers = pd.read_csv(goalscorers_path)

    # Merge shootout info
    results['went_to_shootout'] = results['match_key'].isin(shootouts['match_key'])
    results = results.merge(
        shootouts[['match_key', 'winner', 'first_shooter']],
        on='match_key', how='left'
    )

    # Add thrill index
    results['thrill_index'] = (
        results['total_goals'] * 5 +
        results['goal_diff'].abs().eq(1) * 10 +
        results['went_to_shootout'].fillna(False) * 15
    ).clip(upper=100).astype(int)

    # Binary flags
    results['home_win_flag'] = (results['result_label'] == 'Home Win').astype(int)
    results['away_win_flag'] = (results['result_label'] == 'Away Win').astype(int)
    results['draw_flag'] = (results['result_label'] == 'Draw').astype(int)

    # Simplify names
    results.rename(columns={
        'home_team': 'team_home',
        'away_team': 'team_away',
        'country': 'host_country',
        'city': 'host_city'
    }, inplace=True)

    # Save final merged file
    results.to_csv("matches_featured.csv", index=False)
    print("✅ Merged dataset saved as matches_featured.csv")
    return results


if __name__ == "__main__":
    df = merge_fifa_data()
    print("Final shape:", df.shape)
    print("Columns:", df.columns.tolist())
