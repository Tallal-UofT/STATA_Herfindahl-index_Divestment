# STATA_Herfindahl-index_Divestment
Calculates relevant divestment options from a merger between two firms, as well as the pre-merger, post-merger and delta HHI by market. Can also define a threshold that will exclude divestment options that are not within the bounds set by the threshold.


    tu_HHI -- Can create a table with market shares, both exisitng and post_merger Herfindahl-Hirschman Index (HHI), Delta HHI & divestment options by market and firm.

Syntax

        tu_HHI (Market/Productvarlist) , firms_of_interest(firm 1|firm 2|firm 3...) firm_variable(varname) quantity_variable(varname) [merging_firms(firm 1|firm 2|firm 3...) threshold(integer)]

    options               Description
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Required
      Market(varlist)      Variables to define relevant market by geography and/or product.
      firms_of_interest(string)
                            List of firm names separated by |, these are the firms of interest whose market shares will be shown.
      firm_var(varname)   The variable that contains the names of organization or individuals.
      quantity_variable(var)
                            The variable that contains either the market shares or counts/raw numbers rather than percentages.
    Optional
      merging_firms(string)
                            Creates an extra column with delta HHI values for the merging firms specified separated by |.
      threshold(integer)  Creates a column with divestment options from the firms excluding those merging in the merging_firms option, the integer specifies a cutoff for post_merger market share.

Description
    tu_HHI Can create an output table with Herfindahl-Hirschman Index numbers, Delta HHI, Market Shares for specified firms as well as divestment options by defined markets. Inputs can be market shares as well as raw counts. The "merging_firms" option
    when specified with the names of the merging firms returns the increase in HHI associated with the merging firms. The "threshold" option when specified, with a number between 0 and 1, returns a list of potential divestiture options for a market with
    large HHI and Delta HHI with a cutoff post-divestiture market share of a firm not exceeing the number specified.

Options
        +----------+
    ----+ Required +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    firms_of_interest(string) List of firm names separated by |, these are the firms of interest whose market shares will be shown and will be considered as divestment options.

    firm_var(varname) The variable that contains the names of organization or individuals.

    quantity_variable(varname) The variable that contains either the market shares or counts/raw numbers rather than percentages.

    merging_firms(string) Creates an extra column with delta HHI values for the firms specified separated by |. More than one firm can be specified.

        +----------+
    ----+ Optional +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    merging_firms(string) Creates an extra column with increase in HHI values for the merging firms specified separated by |. More than two firms are specified.

    threshold(integer) Creates a column with divestment options from the firms excluding those merging in the merging_firms option, the integer specifies a cutoff for post_merger market share for a firm. All firms below the cutoff are included. The
        integer must be a value between 0 and 100. NOTE: REQUIRES merging_firms option

Results
        +-----------+
    ----+ Variables +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Share_firms The market share for firms defined in the firms by the different Market/Product.

    delta_HHI The increase in HHI for each market defined in Market/Product due to the merger of firms defined in the merging_firms.

    HHI The Pre and Post merger HHI for each market defined in Market/Product

    divestment_options Returns divestment options from the firms in firms excluding the merging firms in merging_firms and their post-merger market share after divestiture. Options are presented if the market has a HHI greater than 2000 and a HHI
        greater than 200. To qualify a firm must have a post_merger market share not greater than the integer specified in threshold.

Remarks
    There should be no duplicates in terms of (Market/Product varlist) & Firm variable. The program will check.

    Best suited to long format data.

Examples

    . tu_HHI state county , firms("UnitedHealth Group, Inc.|IBT Voluntary Employee Benefits Trust|Tufts Health Plan, Inc|BCBS MA|Anthem Inc.|Missouri Highways and Transportation Commission|Humana Inc.|Fallon Community Health Plan|WellCare Health Plans,
        Inc.|CVS Health Corporation|CIGNA") firm_variable(organization) quantity_variable(Share)

    . tu_HHI state county , firms("UnitedHealth Group, Inc.|IBT Voluntary Employee Benefits Trust|Tufts Health Plan, Inc|BCBS MA|Anthem Inc.|Missouri Highways and Transportation Commission|Humana Inc.|Fallon Community Health Plan|WellCare Health Plans,
        Inc.|CVS Health Corporation|CIGNA") firm_variable(organization) quantity_variable(enrollment) merging_firms("UnitedHealth Group, Inc.|Tufts Health Plan, Inc") threshold(0.10)

    . tu_HHI state county , firms("UnitedHealth Group, Inc.|IBT Voluntary Employee Benefits Trust|Tufts Health Plan, Inc|BCBS MA|Anthem Inc.|Missouri Highways and Transportation Commission|Humana Inc.|Fallon Community Health Plan|WellCare Health Plans,
        Inc.|CVS Health Corporation|CIGNA") firm_variable(organization) quantity_variable(Share) merging_firms("UnitedHealth Group, Inc.|Tufts Health Plan, Inc") threshold(0.30)

References
    https://www.justice.gov/atr/herfindahl-hirschman-index

Author
    Tallal Usman: tallal-usman@outlook.com
