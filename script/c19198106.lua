--只因之猎 终鸡猎手
local m = 19198106
local cm = _G["c"..m]
function cm.initial_effect(c)
    --普通超量召唤
    c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x414),4,2)
    --伤害步骤炸卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
    --本家通天塔
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.desop1)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	--当作超量素材
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.mttg)
	e3:SetOperation(cm.mtop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetLabel(m)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(m)
		Duel.RegisterEffect(ge2,0)
	end
end
--伤害步骤炸卡
function cm.disfilter(c,e)
	return c:IsFaceup() and c:IsReleasable()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and not Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.IsChainDisablable(0)  and #g1>0 then
	local tg1=g1:GetMaxGroup(Card.GetLevel)
	local tg2=g1:GetMaxGroup(Card.GetLink)
	local tg3=g1:GetMaxGroup(Card.GetRank)
	   if  tg1:GetCount()>0 and tg1:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
			 local rg1=tg1:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg1=rg1:Select(1-tp,1,1,nil)
			Duel.Release(sg1,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
	   end
	     if  tg2:GetCount()>0 and tg2:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			 local rg2=tg2:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg2=rg2:Select(1-tp,1,1,nil)
			Duel.Release(sg2,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
		if  tg3:GetCount()>0 and tg3:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
			 local rg3=tg3:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg3=rg3:Select(1-tp,1,1,nil)
			Duel.Release(sg3,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
	    Duel.Destroy(g,REASON_EFFECT)
	end
	Debug.Message("屏幕怎么黑了，双鸡两下试试")
end
--本家通天塔后e1
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.IsChainDisablable(0) and #g1>0 then
	local tg1=g1:GetMaxGroup(Card.GetLevel)
	local tg2=g1:GetMaxGroup(Card.GetLink)
	local tg3=g1:GetMaxGroup(Card.GetRank)
	   if  tg1:GetCount()>0 and tg1:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
			 local rg1=tg1:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg1=rg1:Select(1-tp,1,1,nil)
			Duel.Release(sg1,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
	   end
	     if  tg2:GetCount()>0 and tg2:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			 local rg2=tg2:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg2=rg2:Select(1-tp,1,1,nil)
			Duel.Release(sg2,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
		if  tg3:GetCount()>0 and tg3:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
			 local rg3=tg3:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg3=rg3:Select(1-tp,1,1,nil)
			Duel.Release(sg3,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
	    Duel.Destroy(g,REASON_EFFECT)
	end
	Debug.Message("屏幕怎么黑了，双鸡两下试试")
end
--当作超量素材
function cm.mtfilter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x414) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_HAND,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_HAND,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end