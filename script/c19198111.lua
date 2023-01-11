--只因之苏 鸡式坦克
local m = 19198111
local cm = _G["c"..m]
local loc_mg=LOCATION_MZONE+LOCATION_GRAVE
function cm.initial_effect(c)
	c:EnableReviveLimit()
    --特殊超量召唤
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.xyzcon)
	e0:SetOperation(cm.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--炸3000
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--本家通天塔
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost1)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.target1)
	c:RegisterEffect(e2)
	--效破抗
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--对象抗
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--当作超量素材
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.mttg)
	e5:SetOperation(cm.mtop)
	c:RegisterEffect(e5)
end
--特殊超量召唤
function cm.xyzfilter1(c)
	return c:IsSetCard(0x414) and c:IsType(TYPE_XYZ) and c:IsCanOverlay()
end
function cm.xyzfilter2(c)
	return c:IsSetCard(0x414) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,loc_mg)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.xyzfilter1,tp,loc_mg,0,1,1,nil,ft) and Duel.IsExistingMatchingCard(cm.xyzfilter2,tp,loc_mg,0,1,1,nil,ft1)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,loc_mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local a=Duel.SelectMatchingCard(tp,cm.xyzfilter1,tp,loc_mg,0,1,1,nil,ft)
	local b=Duel.SelectMatchingCard(tp,cm.xyzfilter2,tp,loc_mg,0,1,1,nil,ft)
	
	Duel.Overlay(c,a)
	Duel.Overlay(c,b)
	Debug.Message("XYZ Summon!Come On 鸡式坦克 以苏珊炸碎小黑子")
end
--炸3000
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--通天塔后效果
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1800)
end
--抗性
function cm.con3(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
--当作超量素材
function cm.mtfilter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x414) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_GRAVE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end