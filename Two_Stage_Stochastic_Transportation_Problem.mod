/*********************************************
 * OPL 20.1.0.0 Model
 * Author: pazourlab
 * Creation Date: Apr 23, 2022 at 4:11:38 PM
 *********************************************/

//Setting the number of scenarios
int s= ...;
range scenarios = 1..s;

//Setting the number of arcs
int a = ...;
range edges = 1..a;

//Input parameters
int u[edges][scenarios] = ...;//capacities
int f[edges] = ...;//fixed costs 
int demand = ...;
float shipcost[edges] = ...;
float shortcost = ...;
float prob[scenarios] = ...;


//decision variables 
dvar boolean z[edges];
dvar int+ x[edges][scenarios];
dvar int+ shortfall[scenarios];


//objective function
 minimize sum(e in edges)f[e]*z[e] + sum (s in scenarios,e in edges) prob[s]*x[e][s]*shipcost[e] + sum(s in scenarios) prob[s]*shortfall[s]*shortcost;
 
 subject to {
 	//flow in each arc is nonnegative
   forall (s in scenarios, e in edges)
     x[e][s] >= 0;

	//flow in each arc is nonnegative
   forall (s in scenarios, e in edges)
     x[e][s] <= u[e][s]*z[e];
    
    //the demand node must receive flows equal to the arcs reaching to it 
    forall (s in scenarios)
      x[7][s] + x[8][s] == demand - shortfall[s];
    
    //flow conservation for node C
    forall (s in scenarios)
      x[1][s] + x[2][s] == x[4][s];
 	    
 	//flow conservation for node D
    forall (s in scenarios)
      x[5][s] + x[6][s] == x[3][s];

 	//flow conservation for node E
    forall (s in scenarios)
      x[4][s] + x[5][s] == x[7][s];     
    
    //flow conservation for node F
    forall (s in scenarios)
      x[6][s] == x[8][s];
 }
 
 
 execute {
    writeln("Solutions: ");
	for(var e in edges)
		for(var s in scenarios)
			if(z[e] == 1)
				writeln("arc ", e, " is used to carry ", x[e][s], " units in scenario ", s);
   }