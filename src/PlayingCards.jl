"""
Module to define playing cards
"""
module PlayingCards

import Base: parse, string

export Card, createdeck, deal!, parse, string, suit, suitint, rank, rankint

const suits = tuple(
    "♣", "♦", "♥", "♠"
)
const ranks = tuple(
    "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"
)

# Define Card

struct Card
    value :: Int8
    function Card(value::Integer)
        @assert(0 ≤ value < 52, "value is not in 0:51")
        new(value)
    end
end

# Constructors

function Card(suitint::Int64, rankint::Int64)::Card
    @assert(1 ≤ suitint ≤ 4, "suitint is not in 1:4")
    @assert(1 ≤ rankint ≤ 13, "rankint is not in 1:3")
    return Card((suitint-1) * 13 + (rankint-1))
end

function Card(suit::AbstractString, rank::AbstractString)::Card
    suitint = findfirst(x -> x == suit, suits)
    rankint = findfirst(x -> x == rank, ranks)
    return Card(suitint, rankint)
end

function Card(s::AbstractString)::Card
    sarray = collect(s)
    rankstr = join(sarray[1:end-1])
    suitstr = string(sarray[end])
    return Card(suitstr, rankstr)
end

# Functions for a single card

"""
   suitint(card)
Returns the suit of the card as an integer ∈ 1:4
"""
function suitint(card::Card)
    return (card.value ÷ 13) + 1
end

function suit(card::Card)::String
    return suits[suitint(card)]
end

"""
    rankint(card)
Returns the rank of `card` as an integer ∈ 1:13
"""
function rankint(card::Card)
    return (card.value % 13) + 1
end

function rank(card::Card)::String
    return ranks[rankint(card)]
end

function string(card::Card)
    return "$(rank(card))$(suit(card))"
end

function parse(::Type{Card}, s::AbstractString)
    return Card(s)
end

# Functions for multiple cards

function string(cards::Union{Array{Card,1}, Tuple{Vararg{Card}}})
    return join([string(c) for c in cards], ' ')
end

function parse(::Type{Array{Card,1}}, s::AbstractString)::Array{Card,1}
    return [ Card(cardstr) for cardstr in split(s, ' ') ]
end

"""
    createdeck()
Returns an unshuffled deck of cards (as an array)
"""
function createdeck()::Array{Card,1}
    return [Card(value) for value in 0:51]::Array{Card,1}
end

"""
    deal!(deck, n, p)
Deals `n` cards to `p` players from `deck`, removing cards from `deck` in the
process
"""
function deal!(deck::Array{Card,1}, n::Integer, p::Integer)
    @assert(n * p ≤ length(deck), "cards dealt would exceed the number available")
    hands = [Array{Card}(undef, n) for _ in 1:p]
    for cardnum in 1:n, player in 1:p
            hands[player][cardnum] = pop!(deck)
    end
    return hands
end

end  # module PlayingCards
