require "./nsga2"
require "./eval_context"
require "./functions"
require "./restrictions"
require "./solutions"
require "csv"

context = EvalContext.new(Functions, Solutions, Restrictions)
context.load_variables("info.json")
options = {
  :problem_size => 1,
  :search_space => Array.new(2) {|i| [1, 5]},
  :max_gens => 50,
  :pop_size => 100,
  :p_cross => 0.98
}

(10..13).each do |n|
  context.n = n
  nsga2_instance = Nsga2.new(context, options)
  nsga2_instance.search  
end
