### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ 034e1a58-d3c9-4d28-adc8-29123261c4b0
begin
	using Pkg
	Pkg.activate("/Users/pchaddha/OneDrive - University of Waterloo/Waterloo - 4B/psych_420_intro_to_computational_neuroscience/compNeuroIntro420/juliapsych420")	end

# ╔═╡ 4fdbe30c-8c01-43b6-9387-301a09c6fb83
using Plots

# ╔═╡ 616eaae0-bd30-40ea-afa9-0f1b36a91734
begin
	scatter([0, 1], [1, 0], label="One", markersize=10)
	scatter!([0,1], [0,1], label="Zero", markersize=10)
	scatter!(title="XOR Classification of Key Points", xlabel="Input 1 Value", ylabel="Input 2 Value")
	# savefig("./xor_classification.png")
end

# ╔═╡ e5b34474-5ceb-44f2-ba03-86a50dda41e3
begin
	xs = collect(-0.0:0.1:1.5)
	y1 = [-1*x + 0.5 for x in xs]
	y2 = [-1*x + 1.25 for x in xs]
	
	scatter([0, 1], [1, 0], label="One", markersize=10)
	scatter!([0,1], [0,1], label="Zero", markersize=10)
	plot!(xs, y1, lw=20, fillrange = 1, alpha=0.1, label="Line 1")
	plot!(xs, y2, lw=20, fillrange = -1, alpha=0.1, label="Line 2")
	
	scatter!(title="Line Separation of Key Points", xlabel="Input 1 Value", ylabel="Input 2 Value")
	# savefig("./two_line_separation.png")
end

# ╔═╡ Cell order:
# ╠═034e1a58-d3c9-4d28-adc8-29123261c4b0
# ╠═4fdbe30c-8c01-43b6-9387-301a09c6fb83
# ╠═616eaae0-bd30-40ea-afa9-0f1b36a91734
# ╠═e5b34474-5ceb-44f2-ba03-86a50dda41e3
