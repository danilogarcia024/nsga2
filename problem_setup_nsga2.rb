require "./nsga2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"
require "csv"

def print_solution(context, vector, n)
  
end

context = EvalContext.new(Functions, Solutions, Restrictions)
context.load_variables("info.json")
options = {
  :problem_size => 2,
  :search_space => Array.new(2) {|i| [0, 10]},
  :max_gens => 50,
  :pop_size => 40,
  :p_cross => 0.98
}

(10..13).each do |n|
  context.n = n
  nsga2_instance = Nsga2.new(context, options)
  answer = nsga2_instance.search
  csv = CSV.open("pareto"+context.n.to_s+".csv","wb")
  answer.each do |x|
    csv << x[:objectives]
    #print_solution(context, x[:vector], n)
  end
  csv.close 
end
