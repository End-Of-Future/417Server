--德拉科尼亚·公主
function c289316427.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_NORMAL),1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,289316427)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c289316427.thtg)
	e1:SetOperation(c289316427.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCondition(c289316427.ctcon)
	e2:SetTarget(c289316427.cttg)
	e2:SetOperation(c289316427.ctop)
	c:RegisterEffect(e2)
end
function c289316427.thfi(c)
	return c:IsType(TYPE_NORMAL+TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function c289316427.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c289316427.thfi,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c289316427.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c289316427.thfi,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c289316427.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(288841500)
end
function c289316427.ctfi(c,tp)
	return c:IsControler(1-tp) and c:IsControlerCanBeChanged() and c:IsType(TYPE_EFFECT)
end
function c289316427.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return lg:IsExists(c289316427.ctfi,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function c289316427.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local lg=e:GetHandler():GetLinkedGroup()
	local lc=lg:GetFirst()
	if not lc:IsImmuneToEffect(e) then
		Duel.GetControl(lc,tp)
	end
end
