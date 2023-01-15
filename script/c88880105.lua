--恐啡肽狂龙计划
function c88880105.initial_effect(c) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88880105+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c88880105.accost)
	e1:SetTarget(c88880105.actg)	 
	e1:SetOperation(c88880105.acop) 
	c:RegisterEffect(e1) 
	--negate damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c88880105.damcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c88880105.damop)
	c:RegisterEffect(e2)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND) 
	e2:SetCondition(c88880105.ahcon)
	c:RegisterEffect(e2)	 
end
function c88880105.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c88880105.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x173) 
end 
function c88880105.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88880105.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c88880105.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88880105.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 then 
	local sc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetOperation(c88880105.desop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		sc:RegisterEffect(e3,true)
	end 
end 
function c88880105.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c88880105.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and Duel.GetBattleDamage(tp)>0
end
function c88880105.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c88880105.acfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x173)
end
function c88880105.ahcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c88880105.acfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
