struct MyNewType
    a
    b
end


my1=MyNewType(1,2) # cannot change the fields of the struct once it is establishes
my1.a
my1.b

my1.a = 4
mutable struct MyNewMutableType

    my3=MyNewMutableType(1,2) 
    my3.a
    my3.b

    
     t = typeof(my3)
     newmy4 = t(4,5)


# Abstract types
# all structs that inherit abstract Person must have field 'height')
abstract type AbstractPerson end
# convention:, Caps (struct) abstract types should always start with the word abstract. 

struct TallPerson <: AbstractPerson
    height
end

struct ShortPerson <: AbstractPerson
    height
end

function print_stats(p::AbstractPerson)
    println(p.height)
end

tp = TallPerson(10)  # constructor
sp = ShortPerson(1)

print_stats(tp)
print_stats(sp)


typeof(1)
typeof(2.234)
Int(4.44) # error!
Int(round(4.44))
## custom constructor

struct MyNewType2 
    a::Float64
    b::Int
end
function MyNewType2()
    a = 1
    b = 3
    return MyNewType2  
end

m4 = MyNewType2(1,2)

# Parametric types

struct ParType{T} #curly means types
    a::T
    b::T
end

d =ParType(3.4, 3.4)
c = ParType(4,5)
c = ParType(4,3.4)  # violates the T rule 

function mymult(a::ParType{T}) where T<:AbstractFloat
    return a.a*a.b
end

mymult(d)

struct ParType2{T,U}
    a::T
    b


    # hierarchichal type inheritance
    # abstract type cannot have fields. different from an object oriented. 

   # Homework : make some functions using types and practice some
end

end