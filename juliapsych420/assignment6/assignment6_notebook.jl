### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ 35af1e88-bbf3-49ba-b219-28ea552d667f
using LinearAlgebra

# ╔═╡ e9e6f2a0-8faa-11ec-2fec-f3e27cad1f0f
include("/Users/pchaddha/OneDrive - University of Waterloo/Waterloo - 4B/psych_420_intro_to_computational_neuroscience/compNeuroIntro420/juliapsych420/assignment6/matrix_multiplication.jl")

# ╔═╡ 9c5daae6-e4a2-40b3-bcaa-be86677d2044
md"
# Assignment 6

## Meta
Author: Parmandeep Chaddha
Date: Feb 16, 2022

## Objective
Be able to multiply two matrices, and show that matrix multiplication is not commutative.
"

# ╔═╡ af66a82d-bdad-4d18-b07e-e7b6dc3d08a3
function testCase1()
	matA = [1; 2; 3] # 3x1
	matB = [1 2 3] # 1x3
	# Our expected result is a 1x1 matrix.
	matC = multiplyMatrix(matB, matA)
	return matC
end

# ╔═╡ 976c3f33-8a93-428f-86be-7065552145e4
matC = testCase1()

# ╔═╡ e655db5b-0495-417e-80a8-4b8dcbf7f160
function testCase2()
	matA = [1; 2; 3] # 3x1
	matB = [1 2 3] # 1x3
	# Our expected result is a 3x3 matrix.
	matC = multiplyMatrix(matA, matB)
	return matC
end

# ╔═╡ e8e2769d-40a6-4450-a3ca-d1978dce8107
# Even though MatA and MatB are the same in testCase2, the result should be completely different because of the non-commutitivity of matrix multiplication.
matCNotCommutative = testCase2()

# ╔═╡ feddc50b-12f2-48d1-b9e1-0e876bc4224a
function testCase3()
	matA = [1 2; 3 4] # 2x2
	matB = [2 1; 4 3] # 2x2
	# Our expected result is a 3x3 matrix.
	matC = multiplyMatrix(matA, matB)
	return matC
end

# ╔═╡ 4d0d1b20-3616-46ea-99ff-579fb790006a
matC3 = testCase3()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
"""

# ╔═╡ Cell order:
# ╟─9c5daae6-e4a2-40b3-bcaa-be86677d2044
# ╠═e9e6f2a0-8faa-11ec-2fec-f3e27cad1f0f
# ╠═35af1e88-bbf3-49ba-b219-28ea552d667f
# ╠═af66a82d-bdad-4d18-b07e-e7b6dc3d08a3
# ╠═976c3f33-8a93-428f-86be-7065552145e4
# ╠═e655db5b-0495-417e-80a8-4b8dcbf7f160
# ╠═e8e2769d-40a6-4450-a3ca-d1978dce8107
# ╠═feddc50b-12f2-48d1-b9e1-0e876bc4224a
# ╠═4d0d1b20-3616-46ea-99ff-579fb790006a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
