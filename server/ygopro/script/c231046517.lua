--德拉科尼亚的龙骑兵队长
function c231046517.initial_effect(c)
	aux.EnablePendulumAttribute(c)
--PEffect
--Immuet Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c231046517.tgtg1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(LOCATION_FZONE,0)
	e2:SetTarget(c231046517.tgtg2)
	c:RegisterEffect(e2)
--Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetTarget(c231046517.thtg)
	e3:SetOperation(c231046517.thop)
	c:RegisterEffect(e3)
end
function c231046517.tgtg1(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c231046517.tgtg2(e,c)
	return c:IsCode(213452974)
end
function c231046517.thfi(c)
	return c:IsCode(213452974) and c:IsAbleToHand()
end
function c231046517.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c231046517.thfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c231046517.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c231046517.thfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
