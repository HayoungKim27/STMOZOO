### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ b6d3be69-e654-45eb-892b-58e6914176f5
using PlutoUI, Zygote, Plots, Polynomials, Symbolics

# ╔═╡ 171fee18-20f6-11eb-37e5-2d04caea8c35
md"""
# Link between fractals and the Newton method

By Kim Hayoung and Merckx Anna

## Introduction

In this notebook we discuss the link between fractals and the Newton method. First, we explain what fractals are and where these factals can be found. We then explain what roots of polynomials are and how the Newton's method can approximate these roots. Finally, the link between fractals and the Newton method is made. Here, the important concept called the boundary property will be introduced.

"""

# ╔═╡ 8f9986ac-944c-4f39-9a5c-58114c00c9ea
md"""
## Fractals
"""

# ╔═╡ 0a6b0278-d700-42f0-81f4-7b2d8c6af51f
md"""
Fractals are never-ending patterns that repeat themselves at different scales. Fractals can be found in our everyday life, for example in nature. Natural fractals include branching patterns like trees, river networks, lightning bolts, blood vessels, etc. and spiral patterns like seashells, hurricanes, and galaxies. Fractals cannot only be found in nature, but also in math. A famous mathematical fractal is the Mandelbrot Set. They are formed by calculating a simple equation thousands of times, feeding the answer back into the start. These fractals are infinitely complex, meaning we can zoom in forever.
"""

# ╔═╡ 96be0035-0213-4930-8d1a-3aef17a7f5f9
md"""
![]
(https://github.com/HayoungKim27/STMOZOO/blob/dc6b090e1c098c3e9480abbf39a42e135ac293e1/figure/fractal.png?raw=true)
"""

# ╔═╡ a076a996-5621-45d7-9a46-45a4a482cadd
md"""
Here, we will discuss the Newton Fractal, which finds its roots in applying Newton's method to a fixed polynomial.
"""

# ╔═╡ 09c497a8-4176-42bc-b693-46451842837e
md"""
What does the complexity reflect about an algorithm that is used all over the place in engineering?
"""

# ╔═╡ fb4aeb8c-20f7-11eb-0444-259de7b76883
md"""

## Roots of Polynomials



"""

# ╔═╡ 1e628b95-fc89-4c56-ac34-ec13b3fd9227
md"""

### Introduction

A *root of a polynomial* is the point where the polynomial equals zero. Looking at the graph below, we notice that there are three different places where the graph crosses the x-axis or where $p_5(x)=0$. In other words, ther are three roots of the polynomial $p_5$.
"""

# ╔═╡ a3a8c119-18be-43e5-9e9f-6d96a21822fb
md"""
Finding roots of polynomials is important in many disciplines, but how can we compute them? We'll take a look at three examples: a polynomial of degree two, of degree three and of degree 5. 
"""

# ╔═╡ 11d84496-036e-431a-b5e7-5e9d3a382293
md"""
### Examples
"""

# ╔═╡ eb3e2ee3-7093-4a62-9dc6-b03f68f74ca1
md"""
Let us first take a look at the polynomial $p_2(x)$ of degree 2:

$$p_2(x) = x^2-2$$
"""

# ╔═╡ 1b4f99da-714b-453e-980b-34ce7eab864b
md"""
As we learned in middle school, it is easy to find the roots of a quadratic polynomial ($ax^2 + bx +c$) by using the *quadratic formula*:

> $$r_1, r_2 = \frac {-b ± \sqrt{b^2-4ac}} {2a}$$

Applying this formula to the polynomial $p_2$, gives us the following roots: 

$$r_1, r_2 = \frac { ± \sqrt{-4*1*-2}} {2}$$
$$r_1, r_2 = ± \sqrt{2}$$
"""

# ╔═╡ 06262661-aa56-4a26-981b-74a32822fc58
md"""

However, computing the root of a polynomial becomes trickier when the polynomial has a higher degree. Let us thus now take a look at the polynomial $p_3(x)$ of degree 3:

$$p_3(x) = x^3-x-2$$
"""

# ╔═╡ 6c9bff4a-3cf2-47c6-9b47-bbdc095e66d1
md"""
It looks a bit complicated, but there a formula to find the roots of a cubic polynomial ($x^3 + px +q$), the *cubic formula*:

> $$r = \sqrt[3]{- \frac q 2 + \sqrt{\frac {q^2} {4} + \frac {p^3} {27}})} + \sqrt[3]{- \frac q 2 - \sqrt{\frac {q^2} {4} + \frac {p^3} {27}})}$$

Applying this formula to $p_3$ gives us the following roots: $r_1 = -0.20914$, $r_2 = -0.87888$ and $r_3 = 1.08803$.
"""

# ╔═╡ 54233dea-26e6-49fb-9d03-e6da3af91738
md"""
There is also a *quartic formula* to solve a quartic polynomial, but this one is so complicated that no one actually uses it in practice. What do people use instead and how are roots of polynomials with a higher degree than for calculated? Let us take a look at the final example of the polynomial $p_5(x)$ of degree 5 as given below:

$$p_5(x) = x^5+x^2-x-0.2$$
"""

# ╔═╡ 978cf73a-7194-4987-9476-d38713fe4d48
md"""
For solving the quintic or higher degree of polynomials, there is NO analogous formula. This is known as the **Unsolvability of the Quintic**.

Fortunately, there are some algorithms to approximate solutions with flexible level of precision. A common method is the **Newton's method**.

"""

# ╔═╡ 52e87238-20f8-11eb-2ea0-27ee1208d3c3
md"""
## Newton's method

### Introduction

Newton's method is an iterative process to determine the roots of a function. The method is named after Isaac Newton who invented it. Later, Jospeh Raphson described the method in a more formal way. That is why the method is often referred to as the Newton-Raphson method. In the next section we explain how the Newton's method works. 

First, an initial guess ($x_0$) about the root is made. This initial guess is substituted into $f(x)$ to check whether this equals zero or not. However, it is not likely that our initial guess is a root of the polynomial, so a second and better guess needs to be made. 

To make a better guess, we use a linear approximation. The tangent line to the polynomial is calculated at $x_0$. 

$$y = f(x_0) + f'(x_0)(x-x_0)$$

The intercept of this tangent line and the x-axes is used as our second guess ($x_1$).

$$0 = f(x_0) + f'(x_0)(x_1-x_0)$$
$$x_1 - x_0 = - \frac {f(x_0)}{f'x_0}$$
$$x_1 = x_0 - \frac {f(x_0)}{f'x_0}$$


These two steps - checking if are guess is correct and if not, making a better guess by using a linear approximation - are repeated multiple times. If $x_n$ is the nth guess, the next one can be found by applying the following formula: 

> $$x_{n+1} = x_n - \frac {f(x_n)}{f'x_n}$$

If successfull, the point will approximate the root well after enough repetitions. However, there is an important note. To able to apply this method the function needs to be differentiable. We'll use the Newton's mehod to find the roots of polynomials, which are differentiabel for all arguments. 
"""

# ╔═╡ 9d802ba6-4694-4a0a-8318-c90364bb8f22
md"""

### Example

Let's take a look at the graph below and apply Newton's method to find the roots. We take an initial guess $x_0 = 9$. Since $f(9)$ does not equal zero, we have to make a better guess by using a linear approximation. 

When you check box $1$, the initial guess $x_0$ and the first better guess $x_1$ will be shown on the graph. We notice that $f(x_1)$ still does not equal zero, so another better guess $x_2$ needs to be made. $x_2$ is shown on the graph after checking box $2$, $x_3$ after checking box $3$ and $x_4$ after checking box $4$. $x_4$ seems to approximate the true root quit well. 

1: $(@bind Asc CheckBox()) 2: $(@bind Bsc CheckBox()) 3: $(@bind Csc CheckBox()) 4: $(@bind Dsc CheckBox())

"""

# ╔═╡ 61b071ef-143a-4de2-ab64-3d39e72ee5b2
md"""
Now lets check the true values of $x_1$, $x_2$, $x_3$ and $x_4$ and how good this last one approximates the true root, which is equal to $\sqrt2 = 1.41$.

| $x$   | value|
|:------|:-----|
| $x_1$ | 4.61 |
| $x_2$ | 2.52 |
| $x_3$ | 1.66 |
| $x_4$ | 1.43 |
| $x_5$ | 1.41 |

We see that $x_4$ is not very different from the true root, but taking more steps would approximate the true root even better. We have to define when the true root is approximated well enough. To do this we introduce a parameter $\epsilon$ who determines wether the algorithm is converged. When the difference between two consecutive guesses is smaller than $\epsilon$, the algorithm stops running and we assume the guessed point approximates the true root well enough. This gives us the following pseudocode: 

>**input** starting point ${x}$ **dom** $f$.
>
>**repeat**
>
>> 1. compute next guess $x_{n+1} = x_n - \frac {f(x_n)}{f'x_n}$
>> 2. *Stopping criterion* **break** if $|x_{n+1} - x_n| \leq \epsilon$.
>
>**output** ${x}$
"""

# ╔═╡ 5e5b772a-3be3-4777-9274-12e671ae9fb5
md"""
Below, we can see how increasing $\epsilon$ will result in a greater difference between the true and the estimated root. Decreasing epsilon will result in smaller difference between the true and the estimated root, but will also result in a larger number of steps before the wanted estimate is found. 

Choosing a different starting point, will also have an effect on the number of steps. A starting point that lays closer to the true root, will converge faster than a starting point that lays further away. 
"""

# ╔═╡ 304c6204-2939-4ff4-8b54-aa3210c9c1f6
md"""
Epsilon: $@bind e Slider(0.00000001: 0.001: 0.1, show_value = true)
"""

# ╔═╡ cec0171e-2641-4269-9df2-a6d7a6b1488f
md"""
Startpoint: $@bind xs Slider(1: 1: 100, show_value = true)
"""

# ╔═╡ 00d57234-e37b-490b-b57d-a8b9bb30d459
md"""
It is also important to notice that different starting point can result in finding different roots. In the points where the differential equals zero, the algorithm cannot converge and no root is found. The tangent line will be horizontal and does not cross the x-axis at any point. For $p_2(x) = x^2-2$, this is the case when $x = 0$. 
"""

# ╔═╡ 3935b994-3354-4bb0-aa44-c7f830ab498f
md"""
Startpoint: $@bind xss Slider(-5: 1: 5, show_value = true)
"""

# ╔═╡ 040b4422-e41d-4d52-9192-512297759dc2
md""" The estimated root equals:"""

# ╔═╡ b1551758-20f9-11eb-3e8f-ff9a7127d7f8
md"""
## Newton's fractal

How does the Newton's method give rise to fractals? First of all we have to expand the Newton's method to the complex plain. 

Let us take $p_3 = x^3 - x - 2$ as an example. Althought $p_3$ only has one root, the polynomial can still be factored if we allow roots to be complex numbers. In other words, we can write $p_3 = (x - r_0)(x - r_1)(x - r_2)$ with $r$ pottentially a complex number. For $p_3$ these three values equal $r_0 = -0.761 - 0.858im$,  $r_1 = 1.521+0.0im$, and $r_2 = -0.761 + 0.858im$.
"""

# ╔═╡ 43b7af99-702f-4535-84f5-80f8da716ec6
md"""
In the graph below, the three roots are shown in red. Let us now choose multiple points in the complex plain as starting point. By applying Newton's method, these points will converge to the roots. Some  points converge after a few steps, while others move longer around before converging. This can be seen below by sliding the steps bar. 
"""

# ╔═╡ aebeb4ac-3ea6-4204-a85a-1d7035559517
md"""
Steps: $@bind stp Slider(0: 1: 40, show_value = true)
"""

# ╔═╡ 439797d7-ca15-4153-9769-b0d2f435405e
md"""
We color every points that converged to $r_0$ dark red, every point that converged to $r_1$ orange and every color that converged to $r_2$ yellow. When we reverse the steps, by sliding the bar bak to zero, we notice that points not just simply converge to the closest root. 
"""

# ╔═╡ 98c6c05c-24d9-4984-8643-68d5608b1d30
md"""
Steps: $@bind reverse Slider(0: 1: 40, default = 40, show_value = true)
"""

# ╔═╡ b19384fd-f132-4d1c-b8ad-f20dd38624e1
md"""
On first sight, not much special seems to be happening. But when we increase the resolution and choose many more starting points in the same plane, the following image is found. This is called Newton's fractal. 
"""

# ╔═╡ b851836f-7d1c-4322-bdc7-fd59d236e24c
md"""
This means that in some regions in the complex plane, we can only slightly change our starting point and end up at a different root. Areas close to the true root, don't show this behaviour and points close to a true root converge to that root. The chaos seems to happen in the boundaries between the regions. 
"""

# ╔═╡ c3fad6d4-53ee-4ca8-8c70-a737e21a0485
md"""
There are thus boundary regions in the complex plane, where only a small difference in starting point, results in a convergence to a different root. Let's select some starting points in one of these regions, namely points between $-0.005 - 0.005im$ and $0.005+0.005im$ and check how they behave. 

We notice that these points first move togheter and explode outwards after a few steps. An infinite amount of points in these chaotic regions, all exploding outwards and then converging to different roots, create the *Newton fractal*. 
"""

# ╔═╡ a1b481b5-50a9-414f-95e6-20d9cecfc0d7
md"""
Steps: $@bind behave Slider(0: 1: 40, default = 0, show_value = true)
"""

# ╔═╡ 6b8ad4f0-5b96-4494-badf-95f41aa705f9
md"""
Lets check if this is also the case when using $p_5 = x^5 +x^2 - x - 0.2$ to find a Newton fractal. 
"""

# ╔═╡ 893e50b7-fa6a-4ad4-b82b-e0fa8123034c
md"""
## The boundary property

To explain the boundary property we focus on the Newton fractal of the following polynomial: 

$$p_{boundary} = x^3 - 1$$
"""

# ╔═╡ faad45f5-3ea0-45ed-800c-460a4fd76caa
md"""
The following three plots (Plot 1, 2, and 3) are the same Newton's fractal of the polynomial $p_{boundary}$. But we now focus the attention on just one of the colored regions, instead of three. Thus focussing on all the regions that converge to one of the three roots. 
"""

# ╔═╡ 0fbed847-3807-4dbf-9b20-a810ba8d1809
md"""
- Plot 1 (Focussing on the orange colored region)
"""

# ╔═╡ 2c4e0e8f-1e17-4d75-904d-3ac55ba7b2d4
md"""
- Plot 2 (Focussing on the light blue colored region)
"""

# ╔═╡ 98ab4a10-8803-43ff-a1e4-d5a521bff265
md"""
- Plot 3 (Focussing on the dark blue colored region)
"""

# ╔═╡ 351d288c-29c8-4a73-a9bb-0f78ad37a0c4
md"""
Let us consider the boundary of each colored region(orange, light blue and dark blue).
If all boundary points of the three colored regions are boundary points to each of the three regions, then all three regions will have exactly the same boundary. And surprisingly, the boundary of all three colored regions have the nice three-fold symmetry as shown below. 

**Boundary of one color = Boundary of any other**
"""

# ╔═╡ 474f473b-57f2-4fba-b717-3fe83fa74671
md"""
In other words, for any point selected on the boundary of one colored region, the other two colored regions' boundaries also contain that point. This is called **the boundary property**.
"""

# ╔═╡ 8b70b8c4-5596-4954-9ab5-5911521e9d98
md"""
This property explains why the following pattern is found when applying the Newton's method to a plynomial of degree 2. Here it is clear that any point selected on the boundary of the orange region is also a point on the boundary of the blue region. 
"""

# ╔═╡ 654e6791-0c6a-4231-aece-43f216abd7d2
md"""
## Reference
"""

# ╔═╡ acb9ac75-ee09-4617-b206-5f238b8bd1e4
md"""

Sanderson G. [3Bleu1Brown], (2021). *Newton's Fractal (which Newton knew nothing about)* [video file]. Youtube. https://www.youtube.com/watch?v=-RdOwhmqP5s&t=1376s. Consulted on 03/01/2021. 

Wiersma A.G. (2016). *The Complex Dynamics of Newton's Method*. University of Groningen. 

FractalFoundation (n.d.). *What Is A Fractal?*. https://fractalfoundation.org/fractivities/WhatIsaFractal-1pager.pdf. Consulted on 28/01/2021. 
"""

# ╔═╡ f8148818-5dbc-453b-969f-3d2291f4ede3
md"""

# Code
"""

# ╔═╡ 7b6bb9c0-ce08-4227-9b61-19b90908e479
begin
	
	p2(x) = x^2 - 2
	p3(x) = x^3 - x - 2
	p5(x) = x^5 + x^2 -x - 0.2
	
	p33(x) = x^3 - 1
	
end

# ╔═╡ 4bcfe660-dc83-4961-802e-3946b3075958
gradient_line(x, f, x0) = f(x0) + f'(x0)*(x-x0)

# ╔═╡ cbcd6c43-79c1-49db-bf89-51a3323dad10
new_guess(x, f) = x-f(x)/f'(x)

# ╔═╡ 8755822d-48b5-4d2d-be2e-eca619db8f30
function Newtonsmethod(f, x₀, ϵ = 0.00001)
	
	x = x₀
	steps = 0
	
	while true
		
		Δx = f(x)/f'(x)
		if 	abs(Δx) < ϵ
			break  
		end 	
		x -= Δx 
		steps = steps + 1
		
		if steps == 100
			break 
		end 
	
	end 
	
	return x, steps
	
end 

# ╔═╡ ad7a9721-b96c-47ad-a282-1de22d272c94
round.(Newtonsmethod(p2, xss, 0.00000001)[1]; digits=3)

# ╔═╡ c3d74240-ca7f-46d6-a354-aa684c37d5d1
function next_guess_zygote(f, x₀, n = 100)
	
	@variables z
	fr(z) = real(f(z))
	
	x = x₀
	
	for i = 1:n
		df = gradient(fr, x)[1] |> conj
		x = x - f(x) / df
	end 
	
	return x
	
end 

# ╔═╡ ecd12ef1-6bd6-4a54-b1b7-5bcfb3249b0d
begin 
	
	lower = -2 - 2im
	upper = 2 + 2im

	step_test = 0.5
	
	range_test = [a+b*im for b in real(lower):step_test:real(upper),
						a in imag(lower):step_test:imag(upper)]
	
	root_test = []
	for i = 1:size(range_test, 1)
		for j = 1:size(range_test,2)
			a = next_guess_zygote(p3, range_test[i,j])
			append!(root_test, a)
		end 
	end 
	
	mat_test = reshape(root_test, size(range_test))
	root_mat_test = transpose(mat_test)
end 

# ╔═╡ 3186cdb1-b2c4-4d86-b237-6746244667ec
begin 
	
	lower_chaos = -0.005 - 0.005im
	upper_chaos = 0.005 + 0.005im

	step_chaos = 0.01e-2
	
	range_chaos = [a+b*im for b in real(lower_chaos):step_chaos:real(upper_chaos),
						a in imag(lower_chaos):step_chaos:imag(upper_chaos)]
end 

# ╔═╡ 37d7f09c-bf7b-4f39-a062-3186baf8a3df
begin
	
	test_r0 = []
	test_r1 = []
	test_r2 = []
	
	for i = 1:size(range_test, 1)
		for j = 1:size(range_test,2)
			a = range_test[i, j]
			if root_mat_test[i, j] == root_mat_test[1,1]
				append!(test_r0, a)
			end 
			if root_mat_test[i, j] == root_mat_test[5,1]
				append!(test_r1, a)
			end 
			if root_mat_test[i,j] == root_mat_test[6, 1]
				append!(test_r2, a)
			end 
		end 
	end 
	
end 

# ╔═╡ eef1d0d6-c82b-4e08-b149-504fd911b5ff
begin
	r0 = [-0.76069-0.857874im]
	r1 = [1.52138+0.0im]
	r2 = [-0.76069+0.857874im]
end 

# ╔═╡ ed9effb8-a8db-46da-a72a-5b8920252075
begin
	cold1 = "#00B4D8"
	cold2 = "#0077B6"
	cold3 = "#023E8A"
	cold4 = "#03045E"
	
	warm1 = "#481D24"
	warm2 = "#C5283D"
	warm3 = "#E9724C"
	warm4 = "#FFC857"
	
	neutral4 = "#51c92f"
	
end 

# ╔═╡ 0a3e8c1c-5314-4765-ab9d-ba8f6f0f8289
begin
	plot(x -> p5(x), -1.3, 1.3, color = cold1, lw = 2, label = "\$p_5\$")
	rts = [-1.193, -0.1709, 0.8119]
	hline!([0], color = warm4, label = "")
	scatter!(rts, [0, 0], color = cold4, label = "roots")
end

# ╔═╡ 8d389be5-6ba4-449f-a374-4637bd255b25
begin 
	roots = [-sqrt(2), sqrt(2)]
	plot(x -> p2(x), -2, 2, label = "\$p_2\$", lw = 2, color = cold1)
	hline!([0], color = warm4, label = "")
	scatter!(roots, [0, 0], color = cold4, label = "roots")
end 

# ╔═╡ 5210540d-e08c-4c50-ac39-8a2a504da67c
begin 
	rootsp3 = [1.52137]
	plot(x -> p3(x), -2, 2, label = "\$p_3\$", color = cold1, lw = 2)
	hline!([0], color = warm4, label = "")
	scatter!(rootsp3, [0, 0], color = cold4, label = "root")
end 

# ╔═╡ 058353ca-c47f-4238-85d0-67f54dee59b5
begin
	plot(x -> p5(x), -1.3, 1.3, color = cold1, lw = 2, label = "\$p_5\$")
	hline!([0], color = warm4, label = "")
end

# ╔═╡ 31d9e4fe-3d0b-4780-b3e9-815d696d7641
begin 
	
	x0 = 9
	x1 = new_guess(x0, p2)
	x2 = new_guess(x1, p2)
	x3 = new_guess(x2, p2)
	x4 = new_guess(x3, p2)

	plot(x -> p2(x), -11: 11, xlabel="\$x\$", label = "\$p_2\$", lw=2, color = cold1)
	scatter!([sqrt(2), -sqrt(2)], p2.([(sqrt(2)), (-sqrt(2))]), label = "", color = cold4)


	
	if Asc && !Bsc && !Csc && !Dsc
		scatter!([x0], [p2(x0)], label = "", color=warm4)
		scatter!([x0], [0], label = "\$x_0\$", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [0], label = "\$x_1\$", color=warm3)
	elseif Asc && Bsc && !Csc && !Dsc
		scatter!([x0], [p2(x0)], label = "\$x_0\$", color=warm4)
		scatter!([x0], [0], label = "", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [0], label = "\$x_2\$", color=warm2)
	elseif Asc && !Bsc && Csc && !Dsc
		scatter!([x0], [p2(x0)], label = "", color=warm4)
		scatter!([x0], [0], label = "\$x_0\$", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [0], label = "\$x_1\$", color=warm3)
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "\$x_3\$", color=warm1)
	elseif Asc && !Bsc && !Csc && Dsc
		scatter!([x0], [p2(x0)], label = "", color=warm4)
		scatter!([x0], [0], label = "\$x_0\$", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [0], label = "\$x_1\$", color=warm3)
		scatter!([x3], [0], label = "", color=warm1)
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
	elseif Asc && Bsc && Csc && !Dsc
		scatter!([x0], [p2(x0)], label = "", color=warm4)
		scatter!([x0], [0], label = "\$x_0\$", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "\$x_3\$", color=warm1)
	elseif Asc && Bsc && !Csc && Dsc
		scatter!([x0], [p2(x0)], label = "", color=warm4)
		scatter!([x0], [0], label = "\$x_0\$", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [0], label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
	elseif Asc && !Bsc && Csc && Dsc
		scatter!([x0], [p2(x0)], label = "", color=warm4)
		scatter!([x0], [0], label = "\$x_0\$", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [0], label = "", color=warm3)
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
	elseif Asc && Bsc && Csc && Dsc
		scatter!([x0], [p2(x0)], label = "", color=warm4)
		scatter!([x0], [0], label = "\$x_0\$", color=warm4)
		plot!([x0, x0],[0, p2(x0)], color = warm4, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x0) , 1:10, lw = 2, label = "", color=warm4)
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
		
	elseif !Asc && Bsc && !Csc && !Dsc
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [0], label = "", color=warm2)
	elseif !Asc && Bsc && Csc && !Dsc
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
	elseif !Asc && Bsc && !Csc && Dsc
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [0], label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
	elseif !Asc && Bsc && Csc && Dsc
		scatter!([x1], [p2(x1)], label = "\$x_1\$", color=warm3)
		scatter!([x1], [0], label = "", color=warm3)
		plot!([x1, x1],[0, p2(x1)], color = warm3, linestyle = :dash, label = "")
		plot!(x -> gradient_line(x, p2, x1) , 1:10, lw = 2, label = "", color=warm3)
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
		
	elseif !Asc && !Bsc && Csc && !Dsc
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
	elseif !Asc && !Bsc && Csc && Dsc
		scatter!([x2], [p2(x2)], label = "\$x_2\$", color=warm2)
		scatter!([x2], [0], label = "", color=warm2)
		plot!([x2, x2],[0, p2(x2)], color = warm2, linestyle = :dash, label = "") 
		plot!(x -> gradient_line(x, p2, x2) , 1:10, lw = 2, label = "", color=warm2)
		scatter!([x3], [0], label = "", color=warm1)
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
		
	elseif !Asc && !Bsc && !Csc && Dsc
		scatter!([x3], [p2(x3)], label = "\$x_3\$", color=warm1)
		plot!(x -> gradient_line(x, p2, x3) , 1:10, lw = 2, label = "", color=warm1)
		scatter!([x4], [0], label = "\$x_4\$", color = neutral4)
		
	else 
		plot(x -> p2(x), -11: 11, xlabel="\$x\$", label = "\$p_2\$", lw=2, color = cold1)
		scatter!([sqrt(2), -sqrt(2)], p2.([(sqrt(2)), (-sqrt(2))]), label = "", color = cold4)
	end 

	
end 


# ╔═╡ 81e2713b-f958-4eab-a8ae-41da72c7357f
begin
	guessed_root, steps = Newtonsmethod(p2, xs, e)
	difference = abs(guessed_root - sqrt(2))
	pl1 = plot([0, 0], [0, steps], lw = 100, xlim = (-1,1), ylim = (0, 20), xaxis = nothing, color = warm2, xlabel = "Number of steps", label = "", xguidefontsize=9)
	pl2 = plot([0, 0], [0, difference], lw = 100, xlim = (-1,1), ylim = (0, 0.1), xaxis = nothing, color = warm3, xlabel = "Difference true and estimated root", label = "", xguidefontsize=9)
	plot(pl1, pl2, layout = (1, 2))
end 

# ╔═╡ 19bc70d9-c3da-4d07-b45c-1294760e13b6
begin 
	plot(x -> p3(x), -2, 2, label = "\$p_3\$", color = cold1, lw = 2)
	hline!([0], color = warm4, label = "")
	scatter!(rootsp3, [0, 0], color = cold4, label = "root")
end 

# ╔═╡ 2a5f5dcc-aeab-4a4b-afb7-3ee72766c7a6
begin 
	
	vec_guess = []

	for i = 1:size(range_test, 1)
		for j = 1:size(range_test,2)
			a = next_guess_zygote(p3, range_test[i,j], stp)
			append!(vec_guess, a)
		end 
	end
	
	scatter(real(vec_guess), imag(vec_guess), xlim = (-4, 4), ylim = (-4, 4), label = "", color = cold1, xlabel = "Re(x)", ylabel = "Im(x)")
	scatter!(real(root_test), imag(root_test), color = warm2, label = "roots")
	
end 

# ╔═╡ f3dffd1e-64f0-46cc-8299-b64fd522fe02
begin
	
	vec_guess_r0 = []
	for i = 1:size(test_r0, 1)
		a = next_guess_zygote(p3, test_r0[i], reverse)
		append!(vec_guess_r0, a)
	end
	
	vec_guess_r1 = []
	for i = 1:size(test_r1, 1)
		a = next_guess_zygote(p3, test_r1[i], reverse)
		append!(vec_guess_r1, a)
	end
	
	vec_guess_r2 = []
	for i = 1:size(test_r2, 1)
		a = next_guess_zygote(p3, test_r2[i], reverse)
		append!(vec_guess_r2, a)
	end
	
	scatter(real(r0), imag(r0), xlim = (-4,4), ylim = (-4, 4), color = warm1, label = "\$r_0\$", xlabel = "Re(x)", ylabel = "Im(x)")
	scatter!(real(r1), imag(r1), color = warm3, label = "\$r_1\$")
	scatter!(real(r2), imag(r2), color = warm4, label = "\$r_2\$")
	
	scatter!(real(vec_guess_r0), imag(vec_guess_r0), color = warm1, label = "")
	scatter!(real(vec_guess_r1), imag(vec_guess_r1), color = warm3, label = "")
	scatter!(real(vec_guess_r2), imag(vec_guess_r2), color = warm4, label = "")

	
end

# ╔═╡ 9be8aae1-99f2-4aaf-aa7b-8e21c7bad0b6
begin 
	
	vec_points = []

	for i = 1:size(range_chaos, 1)
		for j = 1:size(range_chaos,2)
			a = next_guess_zygote(p3, range_chaos[i,j], behave)
			append!(vec_points, a)
		end 
	end
	
	scatter(real(vec_points), imag(vec_points), label = "",  xlim = (-10, 10), ylim = (-10, 10), color = cold1, xlabel = "Re(x)", ylabel = "Im(x)")
	scatter!(real(root_test), imag(root_test), color = warm2, label = "roots")
	
end 

# ╔═╡ 5d2a1b18-4e7d-40f7-a80c-5469580818ec
begin

	step = 0.5e-2

	# generate a range of complex values
	   range_0 = [a+b*im for b in real(lower):step:real(upper),
						a in imag(lower):step:imag(upper)]

	# apply the update 100 times
		m = []

		for i = 1:size(range_0, 1)
			for j = 1:size(range_0,2)
				a = next_guess_zygote(p3, range_0[i,j])
				append!(m, a)
			end 
		end 

		n = reshape(m, size(range_0))
		range_p3 = transpose(n)

end

# ╔═╡ b35baa43-eb30-4daa-a56e-885795912d53
begin 
	xsss = [real(lower):step:real(upper)]
	ysss = [imag(lower):step:imag(upper)]

	pp3 = real(range_p3)+imag(range_p3)
	
	heatmap(xsss, ysss, (pp3), color=:RdBu_3, ticks= false, colorbar = nothing)
	scatter!(real(r0), imag(r0), color =:RdBu_3, label = "\$r_0\$", border = :none)
	scatter!(real(r1), imag(r1), color ="#4393c3", label = "\$r_1\$")
	scatter!(real(r2), imag(r2), color ="#f7f7f7", label = "\$r_2\$")
	
end

# ╔═╡ cd5d14d7-8e10-4709-b8c9-5561db44edd0
begin 
	
	m5 = []

	for i = 1:size(range_0, 1)
		for j = 1:size(range_0,2)
			a = next_guess_zygote(p5, range_0[i,j])
			append!(m5, a)
		end 
	end 

	n5 = reshape(m5, size(range_0))
	range_p5 = transpose(n5)
end 

# ╔═╡ 02f2f682-183f-4831-a00d-a9b1ddb26a8e
begin 
	heatmap(xsss, ysss, real(range_p5) + imag(range_p5), color =:RdBu_3, ticks=false, 	  colorbar = nothing, border = :none)
	
	r05 = [-0.170929 + 0.0im]
	r15 = [-1.19295 + 0.0im]
	r25 = [0.0276002 - 1.06392im]
	r35 = [0.811875 + 0.0im]
	r45 = [0.0276002 + 1.06392im]
	
	scatter!(real(r05), imag(r05), color ="#fddbc7", label = "\$r_0\$", border = :none)
	scatter!(real(r15), imag(r15), color =:RdBu_3, label = "\$r_1\$")
	scatter!(real(r25), imag(r25), color ="#ffbb92", label = "\$r_2\$")
	scatter!(real(r35), imag(r35), color ="#92c5de", label = "\$r_3\$")
	scatter!(real(r45), imag(r45), color ="#4393c3", label = "\$r_4\$")
	
end 

# ╔═╡ 3ad688af-952a-4ff7-a218-d7d99470cfea
begin 
	
	m33 = []

	for i = 1:size(range_0, 1)
		for j = 1:size(range_0,2)
			a = next_guess_zygote(p33, range_0[i,j], 200)
			append!(m33, a)
		end 
	end 

	n33 = reshape(m33, size(range_0))
	range_p33 = transpose(n33)
end 

# ╔═╡ 43e5d303-db51-4423-88c4-e88ac1e49ee8
begin 
	heatmap(xsss, ysss, real(range_p33) + imag(range_p33), colorbar = false, color =:RdBu_3, ticks = false, border = :none)
	
	r033 = [-0.5-0.866025im]
	r133 = [- 0.5 + 0.866025im]
	r233 = [1.0 + 0.0im]
	
	scatter!(real(r033), imag(r033), color =:RdBu_3, label = "\$r_0\$")
	scatter!(real(r133), imag(r133), color ="#92c5de", label = "\$r_1\$")
	scatter!(real(r233), imag(r233), color ="#4393c3", label = "\$r_2\$")
	
end 

# ╔═╡ 07fd401d-9f22-4960-aff9-ec6c2078df2c
begin 
	range_p33_orange = copy(range_p33)
	for i = 1:size(range_p33, 1)
		for j = 1:size(range_p33, 2)
			if angle.(range_p33[i,j]) == angle.(range_p33[1,1])
				range_p33_orange[i,j] = -4
			elseif angle.(range_p33[i,j]) == angle.(range_p33[801,1])
				range_p33_orange[i,j] = 1
			elseif angle.(range_p33[i,j]) == angle.(range_p33[1,801])
				range_p33_orange[i,j] = 1
			end
		end 
	end
	
	range_p33_orange[1,1] = 3.5
	
	heatmap(xsss, ysss, real(range_p33_orange) + imag(range_p33_orange), color = :RdGy_3, ticks=false, border = :none, colorbar = nothing)
	
	
end 

# ╔═╡ f2359195-1f17-40a7-a429-42dfff07f06e
begin 
	
	light_blue = "#92c5de"
	grey = "#878787"

	range_p33_lightblue = copy(range_p33)
	for i = 1:size(range_p33, 1)
		for j = 1:size(range_p33, 2)
			if angle.(range_p33[i,j]) < angle.(range_p33[801,1])
				range_p33_lightblue[i,j] = range_p33[801,1] + 2 + 2im
			end 
		end 
	end
	
	color = [light_blue, grey]
	
	heatmap(xsss, ysss, real(range_p33_lightblue) + imag(range_p33_lightblue), ticks=false, border = :none, color = color, colorbar = nothing)
	
end 

# ╔═╡ 29dc085b-6025-4844-a927-d2a9fc2792c7
begin 
	
	range_p33_blue = copy(range_p33)
	for i = 1:size(range_p33, 1)
		for j = 1:size(range_p33, 2)
			if angle.(range_p33[i,j]) == angle.(range_p33[1,1])
				range_p33_blue[i,j] = 1
			elseif angle.(range_p33[i,j]) == angle.(range_p33[801,1])
				range_p33_blue[i,j] = 1
			elseif angle.(range_p33[i,j]) == angle.(range_p33[1,801])
				range_p33_blue[i,j] = -4
			end
		end 
	end
	
	range_p33_orange[1,1] = -3
	
	dark_blue = "#4393c3"
	light_grey = "#E0E0E0"
	colors = [dark_blue, light_grey]
	
	heatmap(xsss, ysss, real(range_p33_blue) + imag(range_p33_blue), color = colors, ticks=false, border = :none, colorbar = nothing)
	
	
end 

# ╔═╡ cd3fbede-c258-43c2-9ab4-2a472ded2480
contour(xsss, ysss, real(range_p33) + imag(range_p33), color = :black, ticks=false, border = :none, colorbar = nothing)

# ╔═╡ 3a4f8e5d-8d6f-42ac-abf3-c6a568aa1d17
begin 
	
	m2 = []

	for i = 1:size(range_0, 1)
		for j = 1:size(range_0,2)
			a = next_guess_zygote(p2, range_0[i,j], 100)
			append!(m2, a)
		end 
	end 

	n2 = reshape(m2, size(range_0))
	range_p2 = transpose(n2)
end 

# ╔═╡ cd1c169c-75e5-40e3-9920-1fda211e86f3
begin 
	heatmap(xsss, ysss, real(range_p2), colorbar = false, color =:RdBu_3, ticks = false, border = :none)
	
	r02 = [sqrt(2) + 0.0im]
	r12 = [-sqrt(2) + 0.0im]
	
	scatter!(real(r02), imag(r02), color ="#92c5de", label = "\$r_0\$")
	scatter!(real(r12), imag(r12), color =:RdBu_3, label = "\$r_1\$")
	
end 

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[compat]
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
Polynomials = "~2.0.24"
Symbolics = "~4.3.0"
Zygote = "~0.6.33"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[ArgCheck]]
git-tree-sha1 = "dedbbb2ddb876f899585c4ec4433265e3017215a"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.1.0"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "ffc6588e17bcfcaa79dfa5b4f417025e755f83fc"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "4.0.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AutoHashEquals]]
git-tree-sha1 = "45bb6705d93be619b81451bb2006b7ee5d4e4453"
uuid = "15f4f7f2-30c1-5605-9d31-71845cf9641f"
version = "0.2.0"

[[BangBang]]
deps = ["Compat", "ConstructionBase", "Future", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables", "ZygoteRules"]
git-tree-sha1 = "a33794b483965bf49deaeec110378640609062b1"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.34"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[Bijections]]
git-tree-sha1 = "705e7822597b432ebe152baa844b49f8026df090"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.3"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ChainRules]]
deps = ["ChainRulesCore", "Compat", "LinearAlgebra", "Random", "RealDot", "Statistics"]
git-tree-sha1 = "a314ee98540af8a189806c3ed074a129c9cf5dd0"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.22.0"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "54fc4400de6e5c3e27be6047da2ef6ba355511f8"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.6"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "6b6f04f93710c71550ec7e16b650c1b9a612d0b6"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.16.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[CompositeTypes]]
git-tree-sha1 = "d5b014b216dc891e81fea299638e4c10c657b582"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.2"

[[CompositionsBase]]
git-tree-sha1 = "455419f7e328a1a2493cabc6428d79e951349769"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.1"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "9bc5dac3c8b6706b58ad5ce24cffd9861f07c94f"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.9.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "08f8555cb66936b871dcfdad09a4f89e754181db"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.40"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "StaticArrays", "Statistics"]
git-tree-sha1 = "5f5f0b750ac576bcf2ab1d7782959894b304923e"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.5.9"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "97f22a337cc0f3d6b303e8496fd9564029d05af0"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.4.2"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "d7ab55febfd0907b285fbf8dc0c73c0825d9d6aa"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.3.0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExprTools]]
git-tree-sha1 = "24565044e60bc48a7562e75bcf14f084901dc0b6"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.7"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "8756f9935b7ccc9064c6eef0bff0ad643df733a3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.7"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "1bd6fc0c344fc0cbee1f42f8d2e7ec8253dda2d2"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.25"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "4a740db447aae0fbeb3ee730de1afbb14ac798a1"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.63.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "aa22e1ee9e722f1da183eb33370df4c1aeb6c2cd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.63.1+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IRTools]]
deps = ["InteractiveUtils", "MacroTools", "Test"]
git-tree-sha1 = "006127162a51f0effbdfaab5ac0c83f8eb7ea8f3"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.4"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "8d70835a3759cdd75881426fced1508bb7b7e1b6"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "22df5b96feef82434b07327e2d3c770a9b21e023"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "LinearAlgebra", "MacroTools", "StaticArrays"]
git-tree-sha1 = "41158dee1d434944570b02547d404e075da15690"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.7.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Metatheory]]
deps = ["AutoHashEquals", "DataStructures", "Dates", "DocStringExtensions", "Parameters", "Reexport", "TermInterface", "ThreadsX", "TimerOutputs"]
git-tree-sha1 = "0886d229caaa09e9f56bcf1991470bd49758a69f"
uuid = "e9d8d322-4543-424a-9be4-0cc815abe26c"
version = "1.3.3"

[[MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "6bb7786e4f24d44b4e29df03c69add1b63d88f01"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.2"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MultivariatePolynomials]]
deps = ["DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "fa6ce8c91445e7cd54de662064090b14b1089a6d"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.4.2"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "73deac2cbae0820f43971fad6c08f6c4f2784ff2"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.3.2"

[[NaNMath]]
git-tree-sha1 = "f755f36b19a5116bb580de457cda0c140153f283"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.6"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "648107615c15d4e09f7eca16307bc821c1f718d8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.13+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "ee26b350276c51697c9c2d88a072b339f9f03d73"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.5"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "92f91ba9e5941fc781fecf5494ac1da87bdac775"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.0"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "68604313ed59f0408313228ba09e79252e4b2da8"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.2"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "db7393a80d0e5bef70f2b518990835541917a544"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.6"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "5c0eb9099596090bb3215260ceca687b888a1575"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.30"

[[Polynomials]]
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "f184bc53e9add8c737e50fa82885bc3f7d70f628"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.24"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "37c1631cb3cc36a535105e6d5557864c82cd8c2b"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.0"

[[RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "ChainRulesCore", "DocStringExtensions", "FillArrays", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "6b96eb51a22af7e927d9618eaaf135a3520f8e2f"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.24.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Referenceables]]
deps = ["Adapt"]
git-tree-sha1 = "e681d3bfa49cd46c3c161505caddf20f0e62aaa9"
uuid = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"
version = "0.1.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cdc1e4278e91a6ad530770ebb327f9ed83cf10c4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "40c1c606543c0130cd3673f0dd9e11f2b5d76cd0"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.26.0"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "0afd9e6c623e379f593da01f20590bacc26d1d14"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.1"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e08890d19787ec25029113e88c34ec20cac1c91e"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.0.0"

[[SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "39c9f91521de844bad65049efd4f9223e7ed43f9"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.14"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "b4912cd034cdf968e06ca5f943bb54b17b97793a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.5.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "2ae4fe21e97cd13efd857462c1869b73c9f61be3"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.2"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "d88665adc9bcf45903013af0982e2fd05ae3d0a6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "51383f2d367eb3b444c961d485c565e4c0cf4ba0"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.14"

[[StatsFuns]]
deps = ["ChainRulesCore", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "bedb3e17cc1d94ce0e6e66d3afa47157978ba404"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.14"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "d21f2c564b21a202f4677c0fba5b5ee431058544"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.4"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "Metatheory", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TermInterface", "TimerOutputs"]
git-tree-sha1 = "8acca4433a95c150fe177512f43bba7377476d97"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.19.6"

[[Symbolics]]
deps = ["ArrayInterface", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "IfElse", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "Metatheory", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TermInterface", "TreeViews"]
git-tree-sha1 = "074e08aea1c745664da5c4b266f50b840e528b1c"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "4.3.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TermInterface]]
git-tree-sha1 = "7aa601f12708243987b88d1b453541a75e3d8c7a"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "0.2.3"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[ThreadsX]]
deps = ["ArgCheck", "BangBang", "ConstructionBase", "InitialValues", "MicroCollections", "Referenceables", "Setfield", "SplittablesBase", "Transducers"]
git-tree-sha1 = "6dad289fe5fc1d8e907fa855135f85fb03c8fa7a"
uuid = "ac1d9e8a-700a-412c-b207-f0111f4b6c0d"
version = "0.1.9"

[[TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "0f1017f68dc25f1a0cb99f4988f78fe4f2e7955f"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.7.1"

[[TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "a5aed757f65c8a1c64503bc4035f704d24c749bf"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.14"

[[Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "3f0945b47207a41946baee6d1385e4ca738c25f7"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.68"

[[TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "IRTools", "InteractiveUtils", "LinearAlgebra", "MacroTools", "NaNMath", "Random", "Requires", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "78da1a0a69bcc86b33f7cb07bc1566c926412de3"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.33"

[[ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─171fee18-20f6-11eb-37e5-2d04caea8c35
# ╟─8f9986ac-944c-4f39-9a5c-58114c00c9ea
# ╟─0a6b0278-d700-42f0-81f4-7b2d8c6af51f
# ╟─96be0035-0213-4930-8d1a-3aef17a7f5f9
# ╟─a076a996-5621-45d7-9a46-45a4a482cadd
# ╟─09c497a8-4176-42bc-b693-46451842837e
# ╟─fb4aeb8c-20f7-11eb-0444-259de7b76883
# ╟─1e628b95-fc89-4c56-ac34-ec13b3fd9227
# ╟─0a3e8c1c-5314-4765-ab9d-ba8f6f0f8289
# ╟─a3a8c119-18be-43e5-9e9f-6d96a21822fb
# ╟─11d84496-036e-431a-b5e7-5e9d3a382293
# ╟─eb3e2ee3-7093-4a62-9dc6-b03f68f74ca1
# ╟─8d389be5-6ba4-449f-a374-4637bd255b25
# ╟─1b4f99da-714b-453e-980b-34ce7eab864b
# ╟─06262661-aa56-4a26-981b-74a32822fc58
# ╟─5210540d-e08c-4c50-ac39-8a2a504da67c
# ╟─6c9bff4a-3cf2-47c6-9b47-bbdc095e66d1
# ╟─54233dea-26e6-49fb-9d03-e6da3af91738
# ╟─058353ca-c47f-4238-85d0-67f54dee59b5
# ╟─978cf73a-7194-4987-9476-d38713fe4d48
# ╟─52e87238-20f8-11eb-2ea0-27ee1208d3c3
# ╟─9d802ba6-4694-4a0a-8318-c90364bb8f22
# ╟─31d9e4fe-3d0b-4780-b3e9-815d696d7641
# ╟─61b071ef-143a-4de2-ab64-3d39e72ee5b2
# ╟─5e5b772a-3be3-4777-9274-12e671ae9fb5
# ╟─304c6204-2939-4ff4-8b54-aa3210c9c1f6
# ╟─cec0171e-2641-4269-9df2-a6d7a6b1488f
# ╟─81e2713b-f958-4eab-a8ae-41da72c7357f
# ╟─00d57234-e37b-490b-b57d-a8b9bb30d459
# ╟─3935b994-3354-4bb0-aa44-c7f830ab498f
# ╟─040b4422-e41d-4d52-9192-512297759dc2
# ╟─ad7a9721-b96c-47ad-a282-1de22d272c94
# ╟─b1551758-20f9-11eb-3e8f-ff9a7127d7f8
# ╟─19bc70d9-c3da-4d07-b45c-1294760e13b6
# ╟─43b7af99-702f-4535-84f5-80f8da716ec6
# ╟─aebeb4ac-3ea6-4204-a85a-1d7035559517
# ╟─2a5f5dcc-aeab-4a4b-afb7-3ee72766c7a6
# ╟─439797d7-ca15-4153-9769-b0d2f435405e
# ╟─98c6c05c-24d9-4984-8643-68d5608b1d30
# ╟─f3dffd1e-64f0-46cc-8299-b64fd522fe02
# ╟─b19384fd-f132-4d1c-b8ad-f20dd38624e1
# ╟─b35baa43-eb30-4daa-a56e-885795912d53
# ╟─b851836f-7d1c-4322-bdc7-fd59d236e24c
# ╟─c3fad6d4-53ee-4ca8-8c70-a737e21a0485
# ╟─a1b481b5-50a9-414f-95e6-20d9cecfc0d7
# ╟─9be8aae1-99f2-4aaf-aa7b-8e21c7bad0b6
# ╟─6b8ad4f0-5b96-4494-badf-95f41aa705f9
# ╟─02f2f682-183f-4831-a00d-a9b1ddb26a8e
# ╟─893e50b7-fa6a-4ad4-b82b-e0fa8123034c
# ╟─43e5d303-db51-4423-88c4-e88ac1e49ee8
# ╟─faad45f5-3ea0-45ed-800c-460a4fd76caa
# ╟─0fbed847-3807-4dbf-9b20-a810ba8d1809
# ╟─07fd401d-9f22-4960-aff9-ec6c2078df2c
# ╟─2c4e0e8f-1e17-4d75-904d-3ac55ba7b2d4
# ╟─f2359195-1f17-40a7-a429-42dfff07f06e
# ╟─98ab4a10-8803-43ff-a1e4-d5a521bff265
# ╟─29dc085b-6025-4844-a927-d2a9fc2792c7
# ╟─351d288c-29c8-4a73-a9bb-0f78ad37a0c4
# ╟─cd3fbede-c258-43c2-9ab4-2a472ded2480
# ╟─474f473b-57f2-4fba-b717-3fe83fa74671
# ╟─8b70b8c4-5596-4954-9ab5-5911521e9d98
# ╟─cd1c169c-75e5-40e3-9920-1fda211e86f3
# ╟─654e6791-0c6a-4231-aece-43f216abd7d2
# ╟─acb9ac75-ee09-4617-b206-5f238b8bd1e4
# ╟─f8148818-5dbc-453b-969f-3d2291f4ede3
# ╠═7b6bb9c0-ce08-4227-9b61-19b90908e479
# ╠═4bcfe660-dc83-4961-802e-3946b3075958
# ╠═cbcd6c43-79c1-49db-bf89-51a3323dad10
# ╠═8755822d-48b5-4d2d-be2e-eca619db8f30
# ╠═c3d74240-ca7f-46d6-a354-aa684c37d5d1
# ╠═ecd12ef1-6bd6-4a54-b1b7-5bcfb3249b0d
# ╠═3186cdb1-b2c4-4d86-b237-6746244667ec
# ╠═37d7f09c-bf7b-4f39-a062-3186baf8a3df
# ╠═eef1d0d6-c82b-4e08-b149-504fd911b5ff
# ╠═b6d3be69-e654-45eb-892b-58e6914176f5
# ╠═ed9effb8-a8db-46da-a72a-5b8920252075
# ╠═5d2a1b18-4e7d-40f7-a80c-5469580818ec
# ╠═cd5d14d7-8e10-4709-b8c9-5561db44edd0
# ╠═3ad688af-952a-4ff7-a218-d7d99470cfea
# ╠═3a4f8e5d-8d6f-42ac-abf3-c6a568aa1d17
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
