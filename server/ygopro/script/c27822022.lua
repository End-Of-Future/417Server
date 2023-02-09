--激流之守护灵
function c27822022.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCondition(c27822022.spcon) 
	e1:SetCountLimit(1,27822022)
	c:RegisterEffect(e1)	
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c27822022.atkcon)
	e2:SetCost(c27822022.atkcost)
	e2:SetOperation(c27822022.atkop)
	c:RegisterEffect(e2) 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c27822022.reptg)
	e2:SetValue(c27822022.repval)
	c:RegisterEffect(e2)
end 
c27822022.XXSplash=true 
function c27822022.filter(c)
	return c:IsFaceup() and c.XXSplash 
end
function c27822022.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c27822022.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c27822022.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ac,bc=Duel.GetBattleMonster(tp) 
	return ac and bc and ac~=c and ac.XXSplash 
end
function c27822022.atkcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end
function c27822022.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac,bc=Duel.GetBattleMonster(tp) 
	if ac:IsRelateToBattle() and ac:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		ac:RegisterEffect(e1)
	end
end
function c27822022.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c.XXSplash and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end 
function c27822022.rrmfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c.XXSplash  
end 
function c27822022.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c27822022.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c27822022.rrmfil,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c27822022.rrmfil,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	end
	return false
end
function c27822022.repval(e,c)
	return c27822022.repfilter(c,e:GetHandlerPlayer())
end




