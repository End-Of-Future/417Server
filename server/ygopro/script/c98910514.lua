--群侠聚金庸
function c98910514.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98910514)
	e1:SetOperation(c98910514.activate)
	c:RegisterEffect(e1)
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x980))
	e2:SetValue(c98910514.val)
	c:RegisterEffect(e2)

--act qp in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x980))
	e4:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e4)
end
function c98910514.atkfilter(c)
	return c:IsSetCard(0x980) and not c:IsPosition(POS_FACEDOWN)
end
function c98910514.val(e)
	return Duel.GetMatchingGroupCount(c98910514.atkfilter,0,LOCATION_GRAVE+LOCATION_ONFIELD,0,c)*200
end
function c98910514.filter(c)
	return c:IsSetCard(0x980) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c98910514.filter1(c)
	return c:IsSetCard(0x980) and c:IsAbleToHand()
end
function c98910514.filter2(c)
	return c:IsSetCard(0x980) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c98910514.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c98910514.filter2,tp,LOCATION_ONFIELD,0,1,nil) then
		local g=Duel.GetMatchingGroup(c98910514.filter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98910514,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg) 
		end
	else
		local g=Duel.GetMatchingGroup(c98910514.filter1,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98910514,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
