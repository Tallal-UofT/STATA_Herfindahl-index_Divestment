{smcl}
{* *! version 2.0.0 06may2019}{...}
{vieweralsosee "[R] help" "help help "}{...}
{viewerjumpto "Syntax" "tu_HHI##syntax"}{...}
{viewerjumpto "Description" "tu_HHI##description"}{...}
{viewerjumpto "Options" "tu_HHI##options"}{...}
{viewerjumpto "Results" "tu_HHI##results"}{...}
{viewerjumpto "Remarks" "tu_HHI##remarks"}{...}
{viewerjumpto "Examples" "tu_HHI##examples"}{...}
{viewerjumpto "References" "tu_HHI##examples"}{...}
{viewerjumpto "Author" "tu_HHI##examples"}{...}


{phang}
{bf:tu_HHI} {hline 2} Can create a table with market shares, both exisitng and post_merger Herfindahl-Hirschman Index (HHI), Delta HHI & divestment options by market and firm.

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab::tu_HHI}
(Market/Product{varlist})
{cmd:,}
firms_of_interest({it:firm 1|firm 2|firm 3...})
firm_variable({varname})
quantity_variable({varname})
[merging_firms({it:firm 1|firm 2|firm 3...})
threshold(integer)]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opth Market(varlist)}}	Variables to define relevant market by geography and/or product.{p_end}
{synopt:{opth firms_of_interest(string)}}List of firm names separated by {cmd:|}, these are the firms of interest whose market shares will be shown.{p_end}
{synopt:{opth firm_var(varname)}}The variable that contains the names of organization or individuals.{p_end}
{synopt:{opth quantity_variable(var)}}The variable that contains either the market shares or counts/raw numbers rather than percentages.{p_end}
{syntab:Optional}
{synopt:{opt merging_firms(string)}}Creates an extra column with delta HHI values for the merging firms specified separated by {cmd:|}.{p_end}
{synopt:{opt threshold(integer)}}Creates a column with divestment options from the {cmd:firms} excluding those merging in the {cmd:merging_firms} option, the integer specifies a cutoff for post_merger market share.{p_end}

{marker description}{...}
{title:Description}
{pstd}
{cmd:tu_HHI} Can create an output table with Herfindahl-Hirschman Index numbers, Delta HHI, Market Shares for specified firms as well as divestment options by defined markets. Inputs can be market shares as well as raw counts. The "merging_firms" option when specified with the names of the merging firms returns the increase in HHI associated with the merging firms. The "threshold" option when specified, with a number between 0 and 1, returns a list of potential divestiture options for a market with large HHI and Delta HHI with a cutoff post-divestiture market share of a firm not exceeing the number specified.

{marker options}{...}
{title:Options}
{dlgtab:Required}
{phang}
{opth firms_of_interest(string)}	List of firm names separated by {cmd:|}, these are the firms of interest whose market shares will be shown and will be considered as divestment options.{p_end}

{phang}
{opth firm_var(varname)}	The variable that contains the names of organization or individuals.{p_end}

{phang}
{opth quantity_variable(varname)}	The variable that contains either the market shares or counts/raw numbers rather than percentages. {p_end}

{phang}
{opt merging_firms(string)}	Creates an extra column with delta HHI values for the firms specified separated by {cmd:|}. More than one firm can be specified.{p_end}

{dlgtab:Optional}

{phang}
{opt merging_firms(string)}	Creates an extra column with increase in HHI values for the merging firms specified separated by {cmd:|}. More than two firms are specified.{p_end}

{phang}
{opt threshold(integer)} Creates a column with divestment options from the {cmd:firms} excluding those merging in the {cmd:merging_firms} option, the integer specifies a cutoff for post_merger market share for a firm. All firms below the cutoff are included. The integer must be a value between 0 and 100. NOTE: REQUIRES merging_firms option{p_end}

{marker results}{...}
{title:Results}
{dlgtab:Variables}

{phang}
{opt Share_firms} The market share for firms defined in the {cmd:firms} by the different {cmd:Market/Product}.

{phang}
{opt delta_HHI} The increase in HHI for each market defined in {cmd:Market/Product} due to the merger of firms defined in the {cmd:merging_firms}.

{phang}
{opt HHI} The Pre and Post merger HHI for each market defined in {cmd:Market/Product}

{phang}
{opt divestment_options} Returns divestment options from the firms in {cmd:firms} excluding the merging firms in {cmd:merging_firms} and their post-merger market share after divestiture. Options are presented if the market has a {cmd:HHI} greater than 2000 and a {cmd:HHI} greater than 200. To qualify a firm must have a post_merger market share not greater than the integer specified in {cmd:threshold}.

{marker remarks}{...}
{title:Remarks}
{phang}
There should be no duplicates in terms of (Market/Product {varlist}) & Firm variable. The program will check.{p_end}

{phang}
Best suited to long format data.{p_end}

{marker examples}{...}
{title:Examples}

{phang}{cmd:. tu_HHI state county , firms("UnitedHealth Group, Inc.|IBT Voluntary Employee Benefits Trust|Tufts Health Plan, Inc|BCBS MA|Anthem Inc.|Missouri Highways and Transportation Commission|Humana Inc.|Fallon Community Health Plan|WellCare Health Plans, Inc.|CVS Health Corporation|CIGNA") firm_variable(organization) quantity_variable(Share)}{p_end}

{phang}{cmd:. tu_HHI state county , firms("UnitedHealth Group, Inc.|IBT Voluntary Employee Benefits Trust|Tufts Health Plan, Inc|BCBS MA|Anthem Inc.|Missouri Highways and Transportation Commission|Humana Inc.|Fallon Community Health Plan|WellCare Health Plans, Inc.|CVS Health Corporation|CIGNA") firm_variable(organization) quantity_variable(enrollment) merging_firms("UnitedHealth Group, Inc.|Tufts Health Plan, Inc") threshold(0.10)}{p_end}

{phang}{cmd:. tu_HHI state county , firms("UnitedHealth Group, Inc.|IBT Voluntary Employee Benefits Trust|Tufts Health Plan, Inc|BCBS MA|Anthem Inc.|Missouri Highways and Transportation Commission|Humana Inc.|Fallon Community Health Plan|WellCare Health Plans, Inc.|CVS Health Corporation|CIGNA") firm_variable(organization) quantity_variable(Share) merging_firms("UnitedHealth Group, Inc.|Tufts Health Plan, Inc") threshold(0.30)}{p_end}

{marker references}{...}
{title:References}
{phang}
{browse "https://www.justice.gov/atr/herfindahl-hirschman-index"}
{p_end}

{marker author}{...}
{title:Author}
{phang}
Tallal Usman: tallal-usman@outlook.com{p_end}

