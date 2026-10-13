// ============================================================================
// 檢舉自動處置：24 小時內被「不同的」3 個人檢舉 → 自動從雷達隱藏，等待人工審查
// 解除方式：在 Firebase 主控台把 moderation/{uid}/hidden 改成 false（或刪除該節點）
// ============================================================================

const AUTO_HIDE_WINDOW_MS = 24 * 60 * 60 * 1000;
const AUTO_HIDE_DISTINCT_REPORTERS = 3;

/**
 * @param {Array<{reporter: string, at: number}>} reports 同一個被檢舉人的所有檢舉
 * @returns {{hide: boolean, reporters: number}}
 */
function evaluateReports(reports, now) {
    const recentReporters = new Set(
        reports
            .filter((r) => r && typeof r.at === 'number' && now - r.at <= AUTO_HIDE_WINDOW_MS)
            .map((r) => r.reporter)
    );
    return {
        hide: recentReporters.size >= AUTO_HIDE_DISTINCT_REPORTERS,
        reporters: recentReporters.size,
    };
}

module.exports = { AUTO_HIDE_WINDOW_MS, AUTO_HIDE_DISTINCT_REPORTERS, evaluateReports };
