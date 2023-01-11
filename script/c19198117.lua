--只因之骑 坤面鸡士油饼
local m = 19198117
local cm = _G["c"..m]
local loc_hg=LOCATION_GRAVE+LOCATION_HAND
function cm.initial_effect(c)
    --普通连接召唤
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,6,cm.lcheck)
    --不能特殊召换
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(cm.linkxyzlimit)
	c:RegisterEffect(e0)
	--特殊超量召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.xyzcon)
	e1:SetOperation(cm.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--改变类型
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.econ)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--三分之一全抗
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.econ)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--无效并破坏
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.discost)
	e4:SetCondition(cm.discon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	--本家通天塔
	local e5=e4:Clone()
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e5:SetCondition(cm.con)
	e5:SetTarget(cm.rmtg)
	e5:SetOperation(cm.rmop)
	c:RegisterEffect(e5)
	--当作超量素材
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,5))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.econ)
	e6:SetTarget(cm.mttg)
	e6:SetOperation(cm.mtop)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_DISABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCondition(cm.indcon)
	e7:SetTarget(cm.indtg)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_DISABLE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e8)
	--抽卡
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,6))
	e9:SetCategory(CATEGORY_DRAW)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(cm.drcon)
	e9:SetTarget(cm.drtg)
	e9:SetOperation(cm.drop)
	c:RegisterEffect(e9)
end
--普通连接召唤
function cm.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSetCard(0x414)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.matfilter,1,nil)
end
--不能特殊召唤
function cm.linkxyzlimit(e,se,sp,st)
	return st&SUMMON_TYPE_XYZ==SUMMON_TYPE_XYZ or st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
--特殊超量召唤
function cm.xyzfilter(c)
	return c:IsSetCard(0x414) and c:IsType(TYPE_XYZ) and c:IsCanOverlay()
end
function cm.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_MZONE,0,2,2,nil,ft)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_MZONE,0,2,2,nil,ft)
	Duel.Overlay(c,g)
	Debug.Message("Xyz Summon!")
	Debug.Message("Henxin!坤面鸡士 油饼")
	Debug.Message("所有的谩骂来源于鸡肚，小黑子你食不食油饼")
end
--改变类型
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_TUNER+TYPE_MONSTER+TYPE_XYZ)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
--三分之一全抗
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--无效并破坏
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_SPELL) and not Duel.IsPlayerAffectedByEffect(tp,19198104) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsChainDisablable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--通天塔后效果
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsPlayerAffectedByEffect(tp,19198104) and rp==1-tp and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and
	e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsChainDisablable(ev)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACE_UP,REASON_EFFECT)
	end
end
--当作超量素材
function cm.mtfilter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x414) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,loc_hg,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,loc_hg,0,1,2,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
--无效抗性
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
--抽卡
function cm.cfilter(c,lg,tp)
	return c:IsSetCard(0x414) and c:IsSummonLocation(LOCATION_EXTRA) and lg:IsContains(c)
		and not Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end
function cm.drfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(cm.cfilter,1,nil,lg,tp)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end