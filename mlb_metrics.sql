-- Leauge Average Payroll Per Year
SELECT
    year,
    AVG(total_payroll_allocations) AS avg_payroll
FROM payrolls
GROUP BY year
ORDER BY year;

-- Leauge Average Wins Per Year
SELECT
    yearID,
    AVG(W) AS avg_wins
FROM teams
GROUP BY yearID
ORDER BY yearID;

-- Division Average Payroll Per Year
SELECT
    t.lgID,
    t.divID,
    t.yearID,
    AVG(p.total_payroll_allocations) AS avg_div_payroll
FROM payrolls p
JOIN teams t
    ON p.team = t.teamID
    AND p.year = t.yearID
GROUP BY t.lgID, t.divID, t.yearID
ORDER BY t.yearID, t.lgID, t.divID;

-- Team Payroll vs. League Average
SELECT
    p.team,
    p.year,
    p.total_payroll_allocations AS payroll,
    AVG(l.avg_payroll) AS league_avg_payroll,
    ROUND(p.total_payroll_allocations - AVG(l.avg_payroll), 2) AS payroll_vs_league_avg
FROM payrolls p
JOIN (
    SELECT
        year,
        AVG(total_payroll_allocations) AS avg_payroll
    FROM payrolls
    GROUP BY year
) l
    ON p.year = l.year
GROUP BY p.team, p.year, p.total_payroll_allocations
ORDER BY p.year, p.team;

-- Payroll vs. Division Average
SELECT
    p.team,
    p.year,
    p.total_payroll_allocations AS payroll,
    d.divID,
    d.avg_div_payroll,
    ROUND(p.total_payroll_allocations - d.avg_div_payroll, 2) AS payroll_vs_div_avg
FROM payrolls p
JOIN teams t
    ON p.team = t.teamID
    AND p.year = t.yearID
JOIN (
    SELECT
        t.divID,
        t.yearID,
        AVG(p.total_payroll_allocations) AS avg_div_payroll
    FROM payrolls p
    JOIN teams t
        ON p.team = t.teamID
        AND p.year = t.yearID
    GROUP BY t.divID, t.yearID
) d
    ON t.divID = d.divID
    AND t.yearID = d.yearID
ORDER BY p.year, p.team;

-- Wins and Win Percentage
SELECT
    teamID,
    yearID,
    W,
    L,
    ROUND(W / (W + L), 3) AS win_pct
FROM teams
ORDER BY yearID, teamID;

-- Wins vs. League Average
SELECT
    t.teamID,
    t.yearID,
    t.W,
    l.avg_wins,
    ROUND(t.W - l.avg_wins, 2) AS wins_vs_league_avg
FROM teams t
JOIN (
    SELECT
        yearID,
        AVG(W) AS avg_wins
    FROM teams
    GROUP BY yearID
) l
    ON t.yearID = l.yearID
ORDER BY t.yearID, t.teamID;

-- Cost Per Win
SELECT
    p.team,
    p.year,
    p.total_payroll_allocations AS payroll,
    t.W,
    CASE
        WHEN t.W > 0 THEN ROUND(p.total_payroll_allocations / t.W, 0)
        ELSE NULL
    END AS cost_per_win
FROM payrolls p
JOIN teams t
    ON p.team = t.teamID
    AND p.year = t.yearID
ORDER BY p.year, p.team;

-- Wins Per Dollar
SELECT
    p.team,
    p.year,
    p.total_payroll_allocations AS payroll,
    t.W,
    CASE
        WHEN p.total_payroll_allocations > 0 THEN ROUND(t.W / p.total_payroll_allocations, 6)
        ELSE NULL
    END AS wins_per_dollar
FROM payrolls p
JOIN teams t
    ON p.team = t.teamID
    AND p.year = t.yearID
ORDER BY p.year, p.team;

-- Run Differential
SELECT
    teamID,
    yearID,
    R,
    RA,
    (R - RA) AS run_diff
FROM teams
ORDER BY yearID, teamID;

-- Cost Per Run Scored
SELECT
    p.team,
    p.year,
    p.total_payroll_allocations AS payroll,
    t.R,
    CASE
        WHEN t.R > 0 THEN ROUND(p.total_payroll_allocations / t.R, 2)
        ELSE NULL
    END AS cost_per_run
FROM payrolls p
JOIN teams t
    ON p.team = t.teamID
    AND p.year = t.yearID
ORDER BY p.year, p.team;

-- Attendance Per Dollar Spent
SELECT
    p.team,
    p.year,
    p.total_payroll_allocations AS payroll,
    t.attendance,
    CASE
        WHEN p.total_payroll_allocations > 0 THEN ROUND(t.attendance / p.total_payroll_allocations, 3)
        ELSE NULL
    END AS attendance_per_dollar
FROM payrolls p
JOIN teams t
    ON p.team = t.teamID
    AND p.year = t.yearID
ORDER BY p.year, p.team;


