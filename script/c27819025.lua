--圣水晶-圣光飞龙
function c27819025.initial_effect(c) 
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e1:SetCountLimit(1,27819025+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c27819025.condition)
	e1:SetTarget(c27819025.target)
	e1:SetOperation(c27819025.activate)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20960340,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c27819025.spcon)
	e2:SetTarget(c27819025.sptg)
	e2:SetOperation(c27819025.spop)
	c:RegisterEffect(e2)
end
c27819025.SetCard_XXLight=true  
c27819025.SetCard_XXLightDragon=true 
function c27819025.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and Duel.GetAttacker():IsAttackAbove(Duel.GetLP(tp))
end
function c27819025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=Duel.GetLP(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,27819025,0,TYPES_EFFECT_TRAP_MONSTER,0,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27819025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,27819025,0,TYPES_EFFECT_TRAP_MONSTER,0,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) then return end
	c:AddMonsterAttribute(TYPE_TRAP+TYPE_EFFECT)
	Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_ATTACK)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c27819025.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetOwnerPlayer(tp)
	c:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	local at=Duel.GetAttacker()
	if at and at:IsAttackable() and at:IsFaceup() and not at:IsImmuneToEffect(e) and not at:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.BreakEffect()
		Duel.ChangeAttackTarget(c)
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(c27819025.getsummoncount(tp),Duel.GetTurnCount())
	e2:SetTarget(c27819025.splimit) 
	e2:SetCondition(c27819025.splcon)
	if Duel.GetTurnPlayer()==tp then 
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2) 
	else 
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN) 
	end 
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetLabel(c27819025.getsummoncount(tp),Duel.GetTurnCount())
	e6:SetValue(c27819025.countval) 
	e6:SetCondition(c27819025.splcon)
	if Duel.GetTurnPlayer()==tp then 
	e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2) 
	else 
	e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)  
	end 
	Duel.RegisterEffect(e6,tp)
end 
function c27819025.splcon(e) 
	local tp=e:GetOwner():GetOwner() 
	local x,turn=e:GetLabel()
	return Duel.GetTurnCount()~=turn and Duel.GetTurnPlayer()==tp 
end 
function c27819025.getsummoncount(tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
end
function c27819025.splimit(e,c,sump,sumtype,sumpos,targetp,se) 
	local x,turn=e:GetLabel() 
	return c27819025.getsummoncount(sump)>x 
end
function c27819025.countval(e,re,tp)
	local x,turn=e:GetLabel() 
	if c27819025.getsummoncount(tp)>x then return 0 else return 1 end
end
function c27819025.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function c27819025.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end 
function c27819025.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c.SetCard_XXLightDragon and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c27819025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c27819025.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27819025.spfil,tp,LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()  
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)   
	tc:CompleteProcedure()  
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c27819025.sefilter) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)   
	tc:RegisterFlagEffect(27819025,RESET_EVENT+RESETS_STANDARD,0,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetLabelObject(tc)
	e2:SetOperation(c27819025.desop) 
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then 
	e2:SetCondition(c27819025.descon1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN) 
	else 
	e2:SetCondition(c27819025.descon2)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)	
	end 
	Duel.RegisterEffect(e2,tp)
	end 
end
function c27819025.sefilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c27819025.descon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(27819025)~=0 then
		return Duel.GetTurnCount()==e:GetLabel() and Duel.GetTurnPlayer()==tp 
	else
		return false
	end
end
function c27819025.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(27819025)~=0 then
		return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp 
	else
		return false
	end
end
function c27819025.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject() 
	Duel.Hint(HINT_CARD,0,27819025)
	Duel.Destroy(tc,REASON_EFFECT) 
	e:Reset()
end





