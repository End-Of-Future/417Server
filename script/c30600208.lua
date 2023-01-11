--S·I·N·异端·虚饰
local m=30600208
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FIEND),2,99,cm.lcheck)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--add setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.tg)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(0xc18)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30600208,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc18)
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)~=0
end
function cm.tg(e,c)
	local rc=e:GetHandler()
	local rg=rc:GetLinkedGroup()
	return rg:IsContains(c)
end
function cm.cfilter(c)
	return c:IsSetCard(0xc18) and not c:IsCode(30600208)
end
function cm.filter(c)
	return c:IsSetCard(0xc18) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and														   Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.Release(g,REASON_EFFECT)~=0 and g2:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SendtoHand(g2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
	end
end


