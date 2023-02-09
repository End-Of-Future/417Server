
--烈火战神总部
local m=66300000
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66300000,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c66300000.activate)
	e1:SetCountLimit(1,66300000+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c66300000.atktg)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66300000,1))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,66300000)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c66300000.thcon)
	e3:SetTarget(c66300000.thtg)
	e3:SetOperation(c66300000.thop)
	c:RegisterEffect(e3)
	
end

function c66300000.filter(c)
	return c:IsSetCard(0xaabb) and c:IsAbleToHand()
end

function c66300000.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66300000.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(66300000,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c66300000.atktg(e,c)
	return c:IsType(TYPE_RITUAL)
end
function c66300000.cfilter(c,tp)
	return c:IsSetCard(0xaabb) and c:IsControler(tp) and c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c66300000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66300000.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c66300000.thfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c66300000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66300000.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c66300000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66300000.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end