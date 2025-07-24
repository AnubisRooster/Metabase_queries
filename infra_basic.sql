SELECT `jira_issues`.`assignee` AS `assignee`, COUNT(*) AS `count`
FROM `jira_issues`
WHERE ((`jira_issues`.`project` = '[project')
    OR (`jira_issues`.`project` = '[project]') OR (`jira_issues`.`project` = '[project]'))
   AND ((`jira_issues`.`status` = 'Closed') OR (`jira_issues`.`status` = 'Done')) AND ((`jira_issues`.`assignee` = '[person]') ) AND (`jira_issues`.`updated_at` >= STR_TO_DATE(CONCAT(DATE_FORMAT(DATE_ADD(NOW(6), INTERVAL -12 month), '%Y-%m'), '-01'), '%Y-%m-%d')) AND (`jira_issues`.`updated_at` < STR_TO_DATE(CONCAT(DATE_FORMAT(NOW(6), '%Y-%m'), '-01'), '%Y-%m-%d')) AND ((`jira_issues`.`issue_type` <> 'Epic') OR (`jira_issues`.`issue_type` IS NULL)) AND ((`jira_issues`.`issue_type` <> 'Initiative') OR (`jira_issues`.`issue_type` IS NULL))
GROUP BY `jira_issues`.`assignee`
ORDER BY `jira_issues`.`assignee` ASC
