--德拉科尼亚的术士
function c255001419.initial_effect(c)
	aux.AddCodeList(c,46052429)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,255001419)
	e1:SetProperty(EFFECT_FLAG_DELAY)   
	e1:SetCondition(c255001419.thcon)
	e1:SetTarget(c255001419.thtg)
	e1:SetOperation(c255001419.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(255001419,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,255001420)
	e2:SetCost(c255001419.cost)
	e2:SetTarget(c255001419.thtg)
	e2:SetOperation(c255001419.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(255001419,1))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetTarget(c255001419.distg)
	e3:SetOperation(c255001419.disop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c255001419.drawvalue)
	c:RegisterEffect(e4)
end
function c255001419.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c255001419.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local gc=g:GetFirst()
	if chk==0 then return gc and gc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,gc,1,1-tp,LOCATION_DECK)
end
function c255001419.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local gc=g:GetFirst()
	Duel.SendtoHand(gc,tp,REASON_EFFECT)
end
function c255001419.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c255001419.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,1-tp,LOCATION_HAND)
end
function c255001419.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local gc=g:RandomSelect(tp,1)
	Duel.SendtoGrave(gc,REASON_EFFECT+REASON_DISCARD)
end
function c255001419.drawvalue(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
