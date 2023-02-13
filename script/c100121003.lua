--奇异双面·学者
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
--SPSummonRule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
--ChangeAttribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.FALSE)
	e3:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
--Light:Negate|Disable
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DISABLE+CATEGORY_COIN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
--Dark:Destroy|Remove
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_COIN)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetCountLimit(1,id+o)
	e5:SetCondition(s.drcon)
	e5:SetTarget(s.drtg)
	e5:SetOperation(s.drop)
	c:RegisterEffect(e5)
end
c100121003.toss_coin=true
function s.sprfi(c)
	return c:IsCode(100121001) and c:GetFlagEffect(100121001)>0 and c:IsReleasable()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.sprfi,tp,LOCATION_MZONE,0,1,nil)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,s.sprfi,tp,LOCATION_MZONE,0,1,1,nil)
	local rc=rg:GetFirst()
	local flag=rc:GetFlagEffect(100121001)
	Duel.Release(rc,REASON_COST)
	if flag>0 then
		e:GetLabelObject():SetCondition(aux.TRUE)
	end
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and (Duel.IsChainNegatable(ev) or Duel.IsChainDisablable(ev))
		and e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		Duel.NegateActivation(ev)
	elseif res==0 then
		Duel.NegateEffect(ev)
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=Duel.TossCoin(tp,1)
	local tc=Duel.GetFirstTarget()
	if res==1 then
		Duel.Destroy(tc,REASON_EFFECT)
	elseif res==0 and tc:IsAbleToRemove() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
