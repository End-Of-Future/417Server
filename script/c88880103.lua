--恐啡肽狂龙·钉状龙
function c88880103.initial_effect(c)
	--chain limit 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c88880103.actop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMING_END_PHASE) 
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,88880103) 
	e2:SetTarget(c88880103.sptg) 
	e2:SetOperation(c88880103.spop)  
	c:RegisterEffect(e2) 
	--copy  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,18880103)
	e3:SetCondition(c88880103.cpcon)
	e3:SetCost(c88880103.cpcost)
	e3:SetTarget(c88880103.cptg)
	e3:SetOperation(c88880103.cpop)
	c:RegisterEffect(e3) 
	--set
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_TO_GRAVE) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetCountLimit(1,28880103)
	e4:SetCondition(function(e) 
	return e:GetHandler():IsReason(REASON_EFFECT) end)
	e4:SetTarget(c88880103.settg) 
	e4:SetOperation(c88880103.setop) 
	c:RegisterEffect(e4) 
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(function(e,c)
	return -Duel.GetLP(e:GetHandlerPlayer()) end) 
	c:RegisterEffect(e5)
	if not c88880103.global_check then
		c88880103.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c88880103.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c88880103.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc and rc:IsSetCard(0x173) and not rc:IsCode(88880103) then 
	Duel.RegisterFlagEffect(rp,88880103,RESET_PHASE+PHASE_END,0,1) 
	end 
end
function c88880103.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) then
		Duel.SetChainLimit(c88880103.chainlm)
	end 
end 
function c88880103.chainlm(e,rp,tp)
	return tp==rp
end
function c88880103.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFlagEffect(tp,88880103)~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
end 
function c88880103.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
	end 
end 
function c88880103.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c88880103.cpfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x173) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(false,true,false)
end
function c88880103.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c88880103.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c88880103.cpfilter,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c88880103.cpfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c88880103.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end 
function c88880103.setfil(c) 
	return c:IsSSetable() and c:IsSetCard(0x173) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end 
function c88880103.settg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88880103.setfil,tp,LOCATION_DECK,0,1,nil) end 
end 
function c88880103.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88880103.setfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SSet(tp,tc)  
	end 
end 





