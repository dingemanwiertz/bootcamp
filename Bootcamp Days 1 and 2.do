**************************
* Pre-sessional bootcamp *
**************************

*----------------------------------------------*
* DW created 22/09/2022, DW updated 27/09/2022 *
*----------------------------------------------* 

/* This do-file accompanies the pre-sessional statistics 
   bootcamp for the MSc SRM. It introduces students to 
   the Stata environment and several basic commands. */ 

/* Changing the working directory: */ 
cd "C:\Users\Dingeman\Bootcamp"
	/* You have to select here the folder on your computer 
	   where you have saved the "WDI_Data" dataset. */ 

/* Loading the data: */ 
use "WDI_Data", clear

	/* Alternatively, you could open data files by
	   double-clicking on them in your file explorer. 
	   Yet, explicitly specifying a working directory 
	   that you will be using is generally safer and 
	   allows for easier reproducibility. */
	   
	*************************
	* 1. Summary statistics *
	*************************
			
		/* 1a. Using the summarize command: */ 
		
			summarize totpop popdens urbpop ///
					gdpcap gini top10p ///
					povrat povgap215 povgap685 ///
					co2intens natresource 	
					
		/* 1b. Using the tabstat command: */ 
		
			tabstat totpop popdens urbpop ///
					gdpcap gini top10p ///
					povrat povgap215 povgap685 ///
					co2intens natresource, ///
					statistics(mean median p10 p90)
					
	****************************
	* 2. First task (slide 22) *
	****************************
	
		/* 2a. How many variables and countries? */ 
					
			/* Properties window tells us we have 62 
			   62 variables and 217 units (countries). 
			   The latter could also be seen from the 
			   number of unique values for the country
			   identifier variables: */ 
			   
			codebook countryname
			
		/* 2b. Number of units per continent? */ 
		
			codebook continent
			
		/* 2c. Variable labels? */ 
		
			describe femmanage armyexp 
			
		/* 2d. Other information for these variables? */ 
		
			codebook femmanage armyexp 
			
		/* 2e. Countries with highest scores? */ 
		
			/* Search in data browser for maximum values
			   for these variables (as identified using 
			   codebook command) and which countries 
			   they belong to. Or, anticipating what we 
			   learn later in this class, you can use 
			   "if" conditions: */
			
			tabulate countryname ///
				if femmanage>77.3 & femmanage!=. 
			tabulate countryname ///
				if armyexp>8.6 & armyexp!=. 
				
			/* Note: Stata stores missing values as 
			   extremely large positive numbers. Hence, 
			   we need to add the second condition: 
			   "variable is not missing". */ 
			   
	***************************
	* 3. Accessing help files *
	***************************
			   
		/* Let's calculate summary statistics: */ 
		
			summarize gdpcap, gini 
		
		/* What is going wrong in the command above? */ 
		
			help summarize
		
		/* Aha, everything behind commas is treated as an 
		   option; we should specify variable list without 
		   commas between the variables: */ 
		   
			summarize gdpcap gini 
		
	********************************
	* 4. Illustrating a few things *
	********************************
	
		/* 4a. Different parts of command syntax: */ 
		
			summarize gdpcap gini ///
				if totpop>10000000, ///
					detail 
				
		/* 4b. How to view your entire dataset: */ 
		
			browse 
		
		/* 4c. How to list data in your Results window: */ 
		
			list countryname hom_mal hom_fem ///
				if gdpcap>30000 & gdpcap!=. & hom_mal!=. ///
				in 1/100
			
	*****************************
	* 5. Second task (slide 44) *
	*****************************
	
		/* 5a. Numerical descriptions: */ 
		
			summarize infmort_mal infmort_fem ///
				sexratio femparl, ///
					detail 
				/* Median = 50th percentile. */ 
					
		/* 5b. Visual descriptions: */ 
		
			histogram sexratio 
			histogram femparl
			
			help histogram
			
			histogram sexratio, bin(30)
			histogram sexratio, width(0.02)
				/* "bin" specifies the number of bars to be 
				   used; "width" the width of the bars. */ 
				   
			histogram sexratio, bin(30) normal 
				/* "normal" adds a scaled density curve to 
				   the plot, with the same mean and standard 
				   deviation as the underlying data. */
				   
		/* 5c. Low vs. high income countries: */ 
		
			summarize gdpcap, detail
				/* Median GDP per capita = 6,590. */ 
				
			summarize infmort_mal infmort_fem ///
				sexratio femparl ///
					if gdpcap<=6590
					
			summarize infmort_mal infmort_fem ///
				sexratio femparl ///
					if gdpcap>6590 & gdpcap!=. 
				/* See note above about how missing 
				   values are stored in Stata. */ 
				   
		/* 5d. Europe vs. Africa: */ 
		
			codebook continent
				/* Africa = 1, Europe = 3. */ 
					
			histogram sexratio ///
				if continent==1, bin(10)
			histogram sexratio ///
				if continent==3, bin(10)
				
			/* We could also do both graphs in one 
			   go, using the "by" option: */ 
			histogram sexratio ///
				if continent==1 | continent==3, ///
					by(continent) bin(10)
			histogram femparl ///
				if continent==1 | continent==3, ///
					by(continent) bin(10)

	*********************
	* 6. T-test example *
	*********************
	
		/* 6a. Preparing income group variable: */ 
		
			generate high_income = 0 
			replace high_income = 1 ///
				if gdpcap>12695 
			replace high_income = . ///
				if gdpcap==. 
				/* The first command creates a new variable 
				   with value 0 for all units; the second
				   and third commands replace these zeros 
				   depending on units' values for "gdpcap". */ 
			
			/* Checking whether data manipulation went OK: */ 
			
			tabulate gdpcap high_income
			tabulate gdpcap high_income, missing
				/* Notice what the "missing" option does. */ 
				
			summarize gdpcap if high_income==0 
			summarize gdpcap if high_income==1 
				/* Based on "tabulate" and "summarize" commands, 
				   our data manipulation worked as expected. */
				  
			/* Labelling the new variable and its values: */ 
			
			label variable high_income ///
				"Whether country is higher-income country"
			label define HIGH_INCOME ///
				0 "Lower-income country" ///
				1 "Higher-income country"
			label values high_income HIGH_INCOME 
				/* First command labels the variable as a whole. 
				   Second command creates labels for its values. 
				   Third command attaches these value labels to 
				   the variable. See "help label" for details. */ 
				
			/* Doing the same thing with "recode": */ 
		
			recode gdpcap ///
				(0/12695 = 0 "Lower-income country") ///
				(12695.01/999999 = 1 "Higher-income country"), ///
					into(high_income_v2)
					
			tabulate high_income high_income_v2
				/* The two variables are indeed the same. */ 
				
		/* 6b. Conducting the T-test: */ 
		
			ttest drinkwater, ///
				by(high_income) unequal
				
	****************************
	* 7. Third task (slide 77) *
	****************************
	
		/* 7a. Formulation of hypothesis: */
		
		   /* Let's test the hypothesis that countries where a 
			  larger share of the population is employed in the 
		      industrial sector emit more CO2 emissions per 
		      dollar of their GDP. */ 
			
		/* 7b. Create grouping variable: */ 
		
			/* Let's create a variable to compare the bottom 
			   quartile of the industry employment variable 
			   to the top quartile of this variable: */ 
			  
				summarize emp_indu, detail
					/* P25 = 15.0, P50 = 19.3; P75 = 24.7 */  
			  
				recode emp_indu ///
					(0/15.01 = 1 "Small industry sector") ///
					(15.02/24.67 = 2 "Medium industry sector") ///
					(24.68/100 = 3 "Large industry sector"), ///
						into(indu_size)
				label variable indu_size ///
					"Size of industry sector (by employment)"
				tabulate emp_indu indu_size, missing 
					/* Recoding worked as expected. */
				
		/* 7c. Conduct the test: */ 
		
			/* Now we conduct the test, comparing countries with 
			   small vs large industry sectors (indu_size 1 vs 3): */ 
		
				ttest co2intens ///
					if indu_size==1 | indu_size==3, ///
						by(indu_size) unequal
					/* Conclusion: The null hypothesis that countries 
					   with small industries emit as much CO2 per 
				       dollar GDP as countries with large industries 
					   can be rejected (t=-5.68; p<0.0001). 
					   There is sufficient evidence to conclude that 
					   the latter emit more CO2 per dollar of GDP. */
				   
		/* 7d. Other tests: */ 
		
			/* Same outcome, comparing countries by income level: */ 
		
				ttest co2intens, ///
					by(high_income) unequal
					/* Conclusion: The null hypothesis of no difference 
					   can be rejected. Relatively speaking (per dollar 
					   of GDP), lower-income countries have significantly
					   dirtier economies than higher-income countries. */
				   
			/* Same outcome, comparing countries from Europe and Asia: */ 
		
				ttest co2intens ///
					if continent==2 | continent==3, ///
						by(continent) unequal
					/* Conclusion: The null hypothesis of no difference 
					   can be rejected. Relatively speaking (per dollar 
					   of GDP), Asian countries have significantly
					   dirtier economies than European countries. */
					   
	*******************
	* 8. Associations *
	*******************
	
		/* Basic scatter plot: */ 
		
			scatter tfr contracep
			
		/* Adding a best-fitting line: */ 
			
			scatter tfr contracep || ///
				lfit tfr contracep 
				
		/* Calculating Pearson's correlation: */ 
		
			pwcorr tfr contracep, ///
				sig obs 
				
	*****************************
	* 9. Fourth task (slide 88) *
	*****************************
	
		/* An example of an unexpected non-correlation: */ 
		
			scatter deathrate gdpcap || ///
				lfit deathrate gdpcap 
			pwcorr deathrate gdpcap, ///
				sig obs
				/* There seems no association between death rates and 
				   GDP per capita. That seems odd, given changes in 
				   healthcare, nutrition, and other risk factors 
				   between poorer and richer countries. Is there 
				   really no association or are we missing something? */ 
				   
		/* A potential omitted variable concerns the age structure 
		   of the population, with richer countries having relatively 
		   more older people, which are purely because of their age 
		   more likely to die than young people: */ 
		   
			summarize oldagedep ///
				if high_income==0, detail 
			summarize oldagedep ///
				if high_income==1, detail 
				
		/* What happens when we consider the relationship between 
		   death rates and GDP per capita while accounting for 
		   countries' age structure? */ 
		   
		    summarize oldagedep, detail 
				/* P25 = 6.0; P50 = 10.4; P75 = 22.0 */ 
				
			/* For relatively young countries: */ 
			scatter deathrate gdpcap ///
				if oldagedep<=6 || ///
			lfit deathrate gdpcap ///
				if oldagedep<=6
			pwcorr deathrate gdpcap ///
				if oldagedep<=6, ///
					sig obs 
					
			/* For relatively old countries: */ 
			scatter deathrate gdpcap ///
				if oldagedep>22 & oldagedep!=. || ///
			lfit deathrate gdpcap ///
				if oldagedep>22 & oldagedep!=. 
			pwcorr deathrate gdpcap ///
				if oldagedep>22 & oldagedep!=., ///
					sig obs 
					
			/* So, once we make sure we compare like for like in terms 
			   of age structure, we do see the expected negative 
			   relationship between GDP per capita and death rates. */ 
			
		/* An example of a likely spurious correlation: */ 
		
			scatter tfr internet 
			pwcorr tfr internet, ///
				sig obs 
				/* Does greater internet access reduce fertility or 
				   is there something else going on? */ 
				   
	**************************
	* 10. Saving our dataset *
	**************************
	
		/* If we want to save a copy of our dataset, with the 
		   newly created variables included, we use "save": */ 
		   
			save "WDI_Data_v2", replace 
				/* See "help save" for more details. */ 
		
				