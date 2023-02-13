--御龙剑士 巴哈斯督·统领
local m=88881102
local cm=_G["c"..m]
	function cm.initial_effect(c)
	 c:SetUniqueOnField(1,0,m)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc7),aux.NonTuner(Card.IsSetCard,0xc7),1)
	c:EnableReviveLimit()
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(cm.distg)
	c:RegisterEffect(e3)
end
	function cm.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
	function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
	function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res then
		local g=teg:Filter(cm.filter1,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.SetTargetCard(g)
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
			e:SetLabel(1)
			e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		end
	end
end
	function cm.filter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
	function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter1,1,nil) end
	local g=eg:Filter(cm.filter1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
	function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
	end
end
	function cm.distg(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
