SELECT 
    CONCAT(YEAR(`jira_issues`.`created_at`), '-Q', 
           QUARTER(`jira_issues`.`created_at`)) AS `Fiscal Quarter`,
    COUNT(DISTINCT `jira_issues`.`id`) AS `Total Bugs`,
    SUM(CASE WHEN `jira_issues`.`reporter` IN ('[person]', '[person]') THEN 1 ELSE 0 END) AS `QA Bugs`,
    ROUND((SUM(CASE WHEN `jira_issues`.`reporter` IN ('[person]', '[person]') THEN 1 ELSE 0 END) / COUNT(DISTINCT `jira_issues`.`id`)) * 100, 2) AS `QA Percentage`
FROM 
    `jira_issues`
WHERE 
    (
        (`jira_issues`.`project` = '[project]')
        OR (`jira_issues`.`project` = '[project]') 
        OR (`jira_issues`.`project` = '[project]')
    )
    AND (`jira_issues`.`created_at` >= CONVERT_TZ('2021-01-01 00:00:00.000', 'UTC', @@session.time_zone)) 
    AND (`jira_issues`.`created_at` < CONVERT_TZ('2024-01-01 00:00:00.000', 'UTC', @@session.time_zone))
    AND (`jira_issues`.`issue_type` = 'Bug') -- Added condition for issue type
GROUP BY 
    CONCAT(YEAR(`jira_issues`.`created_at`), '-Q', QUARTER(`jira_issues`.`created_at`))
ORDER BY 
    `Fiscal Quarter` ASC;
