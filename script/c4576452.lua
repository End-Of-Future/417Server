--反粒子龙
function c4576452.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c4576452.splimit,2,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4576452,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,4576452)
	e1:SetTarget(c4576452.frmtg)
	e1:SetOperation(c4576452.frmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(4576452,1))
	e2:SetTarget(c4576452.hrmtg)
	e2:SetOperation(c4576452.hrmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4576452,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c4576452.negcon)
	e3:SetCost(c4576452.negcost)
	e3:SetTarget(aux.nbtg)
	e3:SetOperation(c4576452.negop)
	c:RegisterEffect(e3)
end
function c4576452.splimit(c)
	return c:IsSetCard(0xaa9,0x1093) and c:IsCanBeLinkMaterial(nil)
end
function c4576452.rmfi(c)
	return c:IsSetCard(0xaa9) and c:IsAbleToGrave()
end
function c4576452.frmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
		and Duel.IsExistingMatchingCard(c4576452.rmfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function c4576452.frmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4576452.rmfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c4576452.hrmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(c4576452.rmfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c4576452.hrmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4576452.rmfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=hg:RandomSelect(tp,1)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c4576452.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not re:GetHandler():IsCode(55063751) and Duel.IsChainNegatable(ev)
end
function c4576452.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4576452.rmfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4576452.rmfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c4576452.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end