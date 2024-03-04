WITH exclusions AS (
                       SELECT jcl.issue_id
                            , Date_trunc('day', jcl.change_date) AS changeDate
                       FROM project_management.jira_change_log AS jcl
                       WHERE jcl.change_field = 'status'
                         AND jcl.change_to IN ('Closed', 'Done', 'Resolved', 'Rejected')
                         AND Date_Trunc('day', jcl.change_date) = CONVERT_TZ('2023-06-30 00:00:00.000', 'UTC', @@session.time_zone)
                         AND jcl.author = 'Mike Poessy'
                   )
   , allIssues  AS (
                       SELECT Date_trunc('month', jcl.change_date) AS changeMonth
                            , 'ClosedIssues' AS IssueType
                            , COUNT(DISTINCT jcl.issue_id) AS Total
                       FROM project_management.jira_change_log AS jcl
                       LEFT OUTER JOIN exclusions AS ex ON ex.issue_id = jcl.issue_id
                           AND ex.changeDate = date_trunc('day', jcl.change_date)
                       LEFT OUTER JOIN project_management.jira_issues AS ji ON jcl.issue_id = ji.id
                       WHERE ex.issue_id IS NULL
                         AND jcl.change_field = 'status'
                         AND jcl.change_to IN ('Closed', 'Done', 'Resolved', 'Rejected')
                         AND LOWER(ji.labels) LIKE '%jira_escalated%'
                         AND jcl.change_date >= CONVERT_TZ('2018-01-01 00:00:00.000', 'UTC', @@session.time_zone)
                         AND ji.project IN ('Database', 'Documentation', 'Engineering Customer Support', 'MongoDB API', 'Platform', 'SingleStoreDB Cloud')
                       GROUP BY date_trunc('month', jcl.change_date)
                       UNION ALL
                       SELECT Date_TRUNC('month', ji.created_at) AS changeMonth
                            , 'CreatedIssues' AS IssueType
                            , COUNT(DISTINCT ji.id) AS Total
                       FROM project_management.jira_issues AS ji
                       WHERE Date_Trunc('month', ji.created_at) >= CONVERT_TZ('2018-01-01 00:00:00.000', 'UTC', @@session.time_zone)
                         AND ji.reporter <> 'PagerDuty'
                         AND ji.reporter_email NOT IN ('psyduck-bot@memsql.com', 'jira-bot@memsql.com')
                         AND LOWER(ji.labels) LIKE '%jira_escalated%'
                         AND ji.project IN ('Database', 'Documentation', 'Engineering Customer Support', 'MongoDB API', 'Platform', 'SingleStoreDB Cloud')
                       GROUP BY Date_TRUNC('month', ji.created_at)
                   )
SELECT ai.changeMonth
     , ai.IssueType
     , ai.Total
FROM allIssues AS ai
ORDER BY ai.changeMonth;
