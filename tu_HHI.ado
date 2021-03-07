capture program drop tu_HHI
ssc install tknz
program tu_HHI
	*Defining the syntax of the program
	version 16.1
	syntax varlist(max=9999) [, firms_of_interest(string) firm_variable(varname max=1) quantity_variable(varname max=1) merging_firms(string) threshold(string)]
	local MarketDefinition `varlist'
	
	di "Market is defined by `MarketDefinition'"
	di "Threshold for mergers is `threshold'"
	di "Firms are identified based on `firm_variable'"
	
	quietly{
	*Task 1: Errors if issues. In other words, if the syntax is incorrect or if variables are not correctly specified.*


	*Checking if Firm variable specified*
	if "`firm_variable'" == "" {
			noisily di as error "Must specify a Firm Variable."
			error 1
		}
		
		
	*Checking if Firms of interest specified*		
	if missing("`firms_of_interest'") {
			noisily di as error "Must specify a Firm or Firms of interest."
			error 1
		}
		
		
		
	*Checking if Market Definition vars specified*
	if "`MarketDefinition'" == "" {
			noisily di as error "Must specify atleast one Geographic and/or Product variable to define relevant Markets."
			error 1
		}
		
		
		
	*Checking if enrollment or market share var specified*
	if "`quantity_variable'" == "" {
			noisily di as error "Must specify a Market Share Variable."
			error 1
		}
		
		
	*Checking if threshold defined for divestment, and if so it is a number between 0 and 100.		
	if !missing("`threshold'") {
		if `threshold'> 100 | `threshold' < 0 {
			noisily di as error "Divestment benchmark must be between 100 and 0."
			error 1
		}
		}
		
			
	*Checking if merging firms specified, assuming threshold option specified.*
	if missing("merging_firms") & !missing("`threshold'") {
			noisily di as error "Calculation of divestment options requires merging_firms option."
			error 1
	}
	
	
	*Checking if duplicates exist.*	
	by `varlist' `firm_variable', sort: gen duplicates = _n
	egen duplicates1 = max(duplicates)
	if  duplicates1 > 1 {
			noisily di as error "Duplicates Exist."
			error 1
	}
	drop duplicates duplicates1
	
	*End of error checking*
	
	
	
	
	*Task 2: Create Market Shares if not already present. In other words if there are enrollment numbers rather than market shares, this will calculate the market shares within the 
	*program.	 *
	by `MarketDefinition', sort: egen total_quantity = sum(`quantity_variable')
	replace `quantity_variable' = (`quantity_variable'/total_quantity)*100
	
	by `varlist', sort: egen SUM1 = sum(`quantity_variable')
		if SUM1 > 101 | SUM1 < 99{ 
			noisily di as error "Market Shares do not sum to a 100%."
			error 1
		}
		drop SUM1	
	
	
	
	
	
	*Task 3: Firms of Interest. Stating which firms we want shown on the table and considered as divestment partners separated by a | *
	noisily di "Processing data to create HHI table with the following firms:"
*Mark firms that should be displayed in final table.*	
*	tokenize "`firms_of_interest'", parse("|")


	
*Calculates HHI by suming the square of market shares. Parses firms of interests. Only these firms will be shown in the final table(assuming they exist in the data)*	
	gen market_share_squared = 					`quantity_variable'^2
	by `MarketDefinition', sort: egen HHI = 	sum(`quantity_variable'^2)
	gen Firm_Interested = 						0

	tknz "`firms_of_interest'", p(|) nochar
	local Number_firms = `s(items)'
	forval company = 1/`s(items)' { 
			noisily di "``company''"
			
			replace Firm_Interested = 			1 if `firm_variable' =="``company''" 
		
	}
	*/
	keep if  Firm_Interested == 				1 
	
	drop Firm_Interested
	*End of specifying firms of interest*
	
	
	
	
	
	
	*Task 4: If merging_firms option specified. Will calculate Delta HHI. Requires that the names of the merging firms be specified separated by a  |. *
	if !missing("`merging_firms'") {
	    noisily display "Calculating Extra column with Delta HHI for merging firms:"
	    tknz "`merging_firms'", p(|) nochar
*Merging firms marked*					
	    gen Merging_Firm = 0
		forval company = 1/`s(items)' {
		    
				
				noisily di "``company''"
				replace Merging_Firm = 		1 if `firm_variable' =="``company''" 
				}
		by `MarketDefinition', sort: egen Merging_Combined_Market = sum(`quantity_variable'*Merging_Firm)
	
*Task 4.1: threshold option specified. Will do some intermediate calculations needed for divestment options to be produced. In this case which is the smaller share of the merging parties specified in the merging_firms.*
		if !missing("`threshold'"){
			egen Market_Def = 											concat(`MarketDefinition')
			by `MarketDefinition', sort: egen smallest_Market_Share = 	min(`quantity_variable'*Merging_Firm) if Merging_Firm== 1
			by `MarketDefinition', sort: egen smallest_Market_Share1 = 	min(smallest_Market_Share)
			drop smallest_Market_Share
	}
	*Task 4.2: The following method used to calculate Delta HHI. Delta HHI = (X+Y)^2 - (X^2 + Y^2) where X and Y denote market share of two merging firms*			
*(X+Y)^2 is specified as HHI_Combined_mfirms*		
		gen HHI_Combined_mfirms	 = 										Merging_Combined_Market^2
		replace Merging_Combined_Market = 								Merging_Combined_Market/100
		
*(X^2 + Y^2) is specified as HHI_separate_mfirms*		
		by `MarketDefinition', sort: egen HHI_separate_mfirms = 		sum(market_share_squared*Merging_Firm)
		gen Delta = 													HHI_Combined_mfirms - HHI_separate_mfirms
		drop HHI_Combined_mfirms HHI_separate_mfirms
	}	
	*Delta HHI calculations complete*
	
	
	
	
	
	
	
	*Task 5: threshold option specified.
	*Wherre the actual divestment options are specified. The divestment options requires that a cutoff be specified beyond which the post_merger market* 	
	*share must not be exceeded in order for a firm to be considered an option*
	if !missing("`threshold'"){
		gen Divest_option = ""
		levelsof Market_Def, local(Market_Def_Local)
*Task 5.1: Marking firms of Interest*		
		foreach u of local Market_Def_Local{
				forval company = 1/`Number_firms' { 

*Task 5.2: Check if non-mering firm meets the divestment crtieria by market.*
						gen _`company' = 			"Firm " + "``company''" if `firm_variable' == "``company''" & Delta > 200 & HHI > 2500 & (`quantity_variable' + smallest_Market_Share1) < (`threshold') & Market_Def == "`u'" & Merging_Firm != 1
						
						gsort `MarketDefinition' -_`company'

*Task 5.3: Pulls down values of _`company'. Stata is pretty bad at doing stuff like creating lists this way. Since we are looping over specified firms and by market, if a firm matches the criteria it only shows up for that row not the entire market, where as our divestment options are at the market level. Hence this is required						
						replace _`company' = 			_`company'[_n-1] if _`company' == ""  & Market_Def == "`u'"
						gen MktShare_divest = 			`quantity_variable' if `firm_variable' == "``company''"
						
						gsort `MarketDefinition' MktShare_divest
*Task 5.4: Similarly pulls down the Market share of a valid divestiture option firm						
						replace MktShare_divest = 		MktShare_divest[_n-1] if missing(MktShare_divest) & Market_Def == "`u'"
						replace MktShare_divest = 		MktShare_divest + smallest_Market_Share1
						replace MktShare_divest = 		round(MktShare_divest, .1)
						
						tostring MktShare_divest, replace force
*Task 5.5: Adding post divestment market shares for valid firms.						
						replace Divest_option = 		Divest_option + "  ," + _`company' +  "(" + MktShare_divest + "%"+ ")"  if _`company' != ""
						
						drop MktShare_divest _`company' 
																						
										}
									}
		replace Divest_option = 						substr(Divest_option,4,.)
						}
*Completed creation of Divestment option column*
	
	
	
	
	
	
	
*Task 6: Cleaning Up Firm names so that the reshape proceeds smoothly.*
	replace `firm_variable' =  							"_" + strtoname(`firm_variable')
*Clean up complete.*
	

	
	
	
*Task 7: Reshape which varias based on whether merging_firms, threshold are specified or not.*
	if !missing("`merging_firms'"){
	    if !missing("`threshold'"){
			keep HHI `firm_variable' `MarketDefinition' `quantity_variable' Delta Divest_option Merging_Combined_Market
			replace `quantity_variable' = 		`quantity_variable'/100
			rename `quantity_variable' Share
			reshape wide Share, i(`MarketDefinition' HHI Delta Divest_option Merging_Combined_Market) j(`firm_variable') string
	}
	
	else if missing("`threshold'"){
			keep HHI `firm_variable' `MarketDefinition' `quantity_variable' Delta Merging_Combined_Market
			replace `quantity_variable' = 		`quantity_variable'/100
			rename `quantity_variable' Share
			reshape wide Share, i(`MarketDefinition' HHI Delta Merging_Combined_Market) j(`firm_variable') string
			order Divest_option, last
		}
	}
	
	else if missing("`merging_firms'") {
		keep HHI `firm_variable' `MarketDefinition' `quantity_variable'
		replace `quantity_variable' =		 	`quantity_variable'/100
		rename `quantity_variable' Share
		reshape wide Share, i(`MarketDefinition' HHI) j(`firm_variable') string
	}
*Reshape complete*
	
	
*Task 8: Sort and rename, as well as droping the mass of local created.*
	rename Delta Delta_HHI
	sort `MarketDefinition'
	gen Post_Merger_HHI = HHI + Delta_HHI
	rename HHI Pre_Merger_HHI
	gsort -Delta_HHI -Pre_Merger_HHI
	macro drop _all
	}
end
