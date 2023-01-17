--设酒杀鸡作食
local m=91460007
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,91460001)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.atg)
	e1:SetOperation(cm.aop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.afilter(c)
	return c:IsAbleToRemoveAsCost() and aux.IsCodeListed(c,91460001)
end
function cm.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsDestructable()
end
function cm.atg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsDestructable() end
	local tg=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,e)
	if chk==0 then return tg:GetCount()>=0 and Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_GRAVE,0,1,tg:GetCount()*2,nil)
	local ct=math.floor(g:GetCount()/5)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=tg:Select(tp,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetTargetCard(sg)
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.tdfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,91460001) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if tc then
		Duel.SendtoDeck(tc,tp,nil,REASON_EFFECT)
	end
end
