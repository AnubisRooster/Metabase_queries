SELECT `jira_issues`.`resolution` AS `resolution`, count(distinct `jira_issues`.`id`) AS `count`
FROM `jira_issues`
WHERE ((`jira_issues`.`reporter` = '[person]')
    OR (`jira_issues`.`reporter` = '[person]'))
   AND ((`jira_issues`.`status` = 'Closed') OR (`jira_issues`.`status` = 'Code Ready') OR (`jira_issues`.`status` = 'Done')) AND ((`jira_issues`.`project` = '[project]') OR (`jira_issues`.`project` = '[project]'))
   AND {{created_at}}
   AND {{project}}
GROUP BY `jira_issues`.`resolution`
ORDER BY `jira_issues`.`resolution` ASC
