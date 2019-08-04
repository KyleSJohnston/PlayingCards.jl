"""
Module to test the PlayingCards module
"""
module PlayingCardsTest

using  Test

using  PlayingCards

@testset "Card Constructors" begin
    for value in 0:51
        c = Card(value)
        @test c isa Card
        @test Card(suitint(c), rankint(c)) == c
        @test Card(suit(c), rank(c)) == c
        @test Card(string(c)) == c
    end
    @test_throws AssertionError Card(52)

end;

@testset "Card Suits and Ranks" begin
    c = Card(0)
    @test suitint(c) == 1
    @test suit(c) == "♣"
    @test rankint(c) == 1
    @test rank(c) == "A"

    c = Card(51)
    @test suitint(c) == 4
    @test suit(c) == "♠"
    @test rankint(c) == 13
    @test rank(c) == "K"
end;

@testset "Deck creation" begin
    deck = createdeck()
    @test length(deck) == 52
    for (i, card) in enumerate(deck)
        @test i == card.value + 1
    end;
end;

@testset "Dealing cards" begin
    deck = createdeck()
    hands = deal!(deck, 13, 4)
    @test length(hands) == 4
    for h in hands
        @test length(h) == 13
        for c in h
            @test c ∉ deck
        end
    end

    deck = createdeck()
    hands = deal!(deck, 6, 2)
    @test length(hands) == 2
    for h in hands
        @test length(h) == 6
        for c in h
            @test c ∉ deck
        end
    end

    deck = createdeck()
    @test_throws AssertionError deal!(deck, 15, 5)
end;

@testset "Parsing Cards" begin
    for suit in PlayingCards.suits, rank in PlayingCards.ranks
        cardstr = join([rank, suit], "")
        @test string(parse(Card, cardstr)) == cardstr
    end

    hand = parse(Array{Card,1}, "8♣ 7♥ 7♠ 6♦")
    @test length(hand) == 4
    for card in hand
        @test card isa Card
    end
    @test string(hand) == "8♣ 7♥ 7♠ 6♦"
    handtuple = tuple(hand...)
    @test string(handtuple) == "8♣ 7♥ 7♠ 6♦"
end;

end
